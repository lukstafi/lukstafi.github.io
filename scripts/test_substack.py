"""Run with: .venv-substack/bin/python -m unittest discover -s scripts -p 'test_*.py'."""
import contextlib
import copy
import io
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock

from publish_to_substack import convert, substackify, _expression
from substack_media import nodes, prepare_images, upload_images, write_preview

ROOT = Path(__file__).resolve().parent.parent


class ExportTest(unittest.TestCase):
    def convert_text(self, text):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'note.md'
            path.write_text(text)
            return convert(path)['body']

    def test_math_parser_and_marks(self):
        body = substackify(self.convert_text(
            r'**$\nabla_\theta$** $\hat V$ $\bar r$ $\mathbb E$ '
            r'$\mathcal L$ $\Gamma$ $\eta$ $V^{\pi_1}$ '
            r'$\infty$ $\subsetneq$ $\leftarrow$ $\{x\}$'))
        text = ''.join(n.get('text', '') for n in nodes(body))
        for token in ['∇', 'θ', 'V̂', 'r̄', '𝔼', 'ℒ', 'Γ', 'η', 'V^(π₁)', '∞', '⊊', '←', '{x}']:
            self.assertIn(token, text)
        self.assertNotIn('\\', text)
        self.assertEqual(body['content'][0]['content'][0]['marks'], [{'type': 'strong'}])

    def test_fallback_and_block_structure(self):
        source = self.convert_text(r'- Before $G_t=\sum_{k=t}^{T-1}r_k$ after.')
        with contextlib.redirect_stderr(io.StringIO()) as log:
            body = substackify(source)
        self.assertIn('block equation', log.getvalue())
        item = body['content'][0]['content'][0]
        self.assertEqual([n['type'] for n in item['content']], ['paragraph', 'latex_block', 'paragraph'])
        self.assertIn(r'\sum', item['content'][1]['attrs']['persistentExpression'])
        for mode in ['block', 'native', 'raw', 'unicode']:
            with self.subTest(mode=mode):
                out = substackify(self.convert_text('## Before $x$ after\n\n- $y$'), mode)
                for node in nodes(out):
                    if node['type'] in {'paragraph', 'heading'}:
                        self.assertFalse(any(n['type'] == 'latex_block' for n in node.get('content', [])))
                self.assertEqual(out['content'][-1]['content'][0]['content'][0]['type'], 'paragraph')

    def test_native_preserves_tex_and_links(self):
        body = substackify(self.convert_text(r'[$\frac{a}{b}$](https://example.com)'), 'native')
        node = body['content'][0]['content'][0]
        self.assertEqual(node['type'], 'inline_latex')
        self.assertEqual(node['attrs']['persistentExpression'], r'\frac{a}{b}')
        self.assertEqual(node['marks'][0]['type'], 'link')
        self.assertEqual(_expression('x % explanation\n + y'), 'x + y')
        self.assertEqual(_expression(r'x\% + y'), r'x\% + y')

    def test_figures_and_upload(self):
        with tempfile.TemporaryDirectory() as folder:
            folder = Path(folder)
            path = folder / 'article.md'
            (folder / 'diagram.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60"><rect width="100" height="60" fill="red"/></svg>')
            path.write_text('![Caption & alt](diagram.svg)\n\nBefore ![Inline diagram](diagram.svg) after.')
            body = substackify(convert(path)['body'])
            self.assertEqual(sum(n['type'] == 'export_image' for n in nodes(body)), 2)
            prepare_images(body, path, folder / 'assets')
            imgs = [n for n in nodes(body) if n['type'] == 'image2']
            self.assertEqual(len(imgs), 2)
            self.assertEqual((imgs[0]['attrs']['width'], imgs[0]['attrs']['height']), (200, 120))
            self.assertEqual(imgs[0]['attrs']['alt'], 'Caption & alt')
            self.assertEqual(sum(n['type'] == 'caption' for n in nodes(body)), 1)
            doc = {'title': '<Unsafe title>', 'body': body}
            write_preview(doc, folder / 'preview.html')
            preview = (folder / 'preview.html').read_text()
            self.assertNotIn('file://', preview)
            self.assertIn('&lt;Unsafe title&gt;', preview)
            api = Mock()
            api.get_image.return_value = {'url': 'https://substackcdn.com/test.png'}
            upload_images(body, api)
            api.get_image.assert_called_once()
            self.assertTrue(all(n['attrs']['src'].startswith('https://') for n in imgs))

    def test_missing_image_and_failed_upload(self):
        body = {'type': 'export_image', 'src': 'missing.svg'}
        with self.assertRaisesRegex(ValueError, 'Image not found'):
            prepare_images(body, Path('/tmp/article.md'), Path('/tmp/assets'))
        api = Mock()
        api.get_image.return_value = {'error': 'failed'}
        with self.assertRaisesRegex(ValueError, 'HTTPS image URL'):
            upload_images({'type': 'image2', 'attrs': {'src': 'https://example.com/a.png'}}, api)

    def test_table_modes_keep_cells_math_and_escaping(self):
        source = self.convert_text('| Method | Value |\n|---|---|\n| A & B | $\\frac{1}{2}$ |\n| `x_y` | 50% |')
        out = substackify(copy.deepcopy(source), table_mode='list')
        text = ''.join(n.get('text', '') for n in nodes(out))
        self.assertIn('Method', text)
        self.assertIn('A & B', text)
        self.assertIn('50%', text)
        self.assertEqual(sum(n['type'] == 'list_item' for n in nodes(out)), 2)
        latex = substackify(source, table_mode='latex')['content'][0]['attrs']['persistentExpression']
        for part in [r'\begin{array}{ll}', r'\frac{1}{2}', r'\&', r'\%', r'\_']:
            self.assertIn(part, latex)
        self.assertNotIn(r'\text{\frac', latex)

    def test_html_table(self):
        source = self.convert_text('<table>\n<tr>\n<th>\nName\n</th>\n<th>\nValue\n</th>\n</tr>\n<tr>\n<td>\nAlpha\n</td>\n<td>\n$\\alpha$\n</td>\n</tr>\n</table>')
        out = substackify(source)
        text = ''.join(n.get('text', '') for n in nodes(out))
        for token in ['Name', 'Value', 'Alpha', 'α']:
            self.assertIn(token, text)

    def test_two_newest_essays(self):
        for slug, images in [('how-does-a-policy-improve', 2),
                             ('how-can-a-reward-train-a-neural-network', 1)]:
            with self.subTest(slug=slug), tempfile.TemporaryDirectory() as folder:
                path = ROOT / 'notes' / (slug + '.md')
                source = convert(path)['body']
                expected_display = sum(n['type'] == 'display_math' for n in nodes(source))
                expected_inline = sum(n['type'] == 'inline_math' for n in nodes(source))
                self.assertGreater(expected_inline, 100)
                for mode in ['unicode', 'native']:
                    with contextlib.redirect_stderr(io.StringIO()):
                        out = substackify(copy.deepcopy(source), mode)
                    prepare_images(out, path, Path(folder))
                    ns = list(nodes(out))
                    self.assertEqual(sum(n['type'] == 'image2' for n in ns), images)
                    self.assertEqual(sum(n['type'] == 'caption' for n in ns), images)
                    self.assertGreaterEqual(sum(n['type'] == 'latex_block' for n in ns), expected_display)
                    self.assertFalse(any(n['type'].startswith('export_') for n in ns))
                    self.assertFalse(any('\\' in n.get('text', '') for n in ns))
                    if mode == 'native':
                        self.assertEqual(sum(n['type'] == 'inline_latex' for n in ns), expected_inline)


if __name__ == '__main__':
    unittest.main()
