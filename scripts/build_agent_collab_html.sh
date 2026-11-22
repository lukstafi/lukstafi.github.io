#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
collab_dir="$root_dir/projects/jca/agent-collab"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found on PATH" >&2
  exit 1
fi

# Build function for a single markdown file
build_html() {
  local input_md="$1"
  local output_html="$2"
  local title="$3"

  if [[ ! -f "$input_md" ]]; then
    echo "warning: input file not found: $input_md" >&2
    return 1
  fi

  mkdir -p "$(dirname -- "$output_html")"

  # Link-preview meta tags (Open Graph, Twitter card) from the index entry.
  local og_meta
  og_meta="$(python3 "$root_dir/scripts/og_meta.py" "${output_html#"$root_dir/"}" "$title")"

  pandoc \
    --from=markdown+tex_math_dollars+tex_math_single_backslash \
    --to=html5 \
    --standalone \
    --section-divs \
    --template="$root_dir/assets/tufte.html5" \
    --css="/assets/tufte.css" \
    --css="/assets/pandoc-tufte.css" \
    --css="/assets/site.css" \
    --include-before-body="$root_dir/assets/nav.html" \
    --toc \
    --toc-depth=3 \
    --mathjax="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" \
    --metadata=pagetitle:"$title" \
    --variable=og-meta:"$og_meta" \
    "$input_md" \
    -o "$output_html"

  echo "wrote: $output_html"
}

# Build main collaboration papers
build_html \
  "$collab_dir/collab-paper-claude.md" \
  "$collab_dir/collab-paper-claude.html" \
  "JCAQP Undecidability Analysis - Claude"

build_html \
  "$collab_dir/collab-paper-codex.md" \
  "$collab_dir/collab-paper-codex.html" \
  "JCAQP Undecidability Analysis - Codex"

build_html \
  "$collab_dir/round-8-reassessment.md" \
  "$collab_dir/round-8-reassessment.html" \
  "JCA Existence over T(F), Round 8: Reassessment"

build_html \
  "$collab_dir/round-9-subsumption-bottleneck.md" \
  "$collab_dir/round-9-subsumption-bottleneck.html" \
  "JCA Existence over T(F), Round 9: The Subsumption Bottleneck"

build_html \
  "$collab_dir/round-10-witness-generalization.md" \
  "$collab_dir/round-10-witness-generalization.html" \
  "JCA Existence over T(F), Round 10: Witness Generalization"

build_html \
  "$collab_dir/round-11-witness-bounds.md" \
  "$collab_dir/round-11-witness-bounds.html" \
  "JCA Existence over T(F), Round 11: Witness Bounds and a Constant-Test Fragment"

build_html \
  "$collab_dir/round-12-same-shape.md" \
  "$collab_dir/round-12-same-shape.html" \
  "JCA Round 12: How Much Tree Shape Do Two Branches Need?"

build_html \
  "$collab_dir/round-13-forced-copies.md" \
  "$collab_dir/round-13-forced-copies.html" \
  "JCA Round 13: What Forces the Next Copy?"

build_html \
  "$collab_dir/round-14-undecidability.md" \
  "$collab_dir/round-14-undecidability.html" \
  "JCA Round 14: Ordinary Finite-Term Joint Constraint Abduction Is Undecidable"

build_html \
  "$collab_dir/round-14-four-branches.md" \
  "$collab_dir/round-14-four-branches.html" \
  "JCA Round 14: Four Branches over One Binary Constructor"

build_html \
  "$collab_dir/round-15-constructor-free.md" \
  "$collab_dir/round-15-constructor-free.html" \
  "JCA Round 15: Constructor-Free Input Is Undecidable"

build_html \
  "$collab_dir/round-16-fixed-flat.md" \
  "$collab_dir/round-16-fixed-flat.html" \
  "JCA Round 16: A Fixed Number of Constructor-Free Branches"

build_html \
  "$collab_dir/round-17-three-branches.md" \
  "$collab_dir/round-17-three-branches.html" \
  "JCA Round 17: Three Branches over One Binary Constructor and One Constant"

build_html \
  "$collab_dir/round-18-signature-boundary.md" \
  "$collab_dir/round-18-signature-boundary.html" \
  "JCA Round 18: The Constructor Arity Boundary"

build_html \
  "$collab_dir/round-19-designated-parameters.md" \
  "$collab_dir/round-19-designated-parameters.html" \
  "JCA Round 19: Designated Parameters and Two-Branch Prefix Hardness"

build_html \
  "$collab_dir/round-20-one-branch.md" \
  "$collab_dir/round-20-one-branch.html" \
  "JCA Round 20: One Implication under an Alternating Prefix"

build_html \
  "$collab_dir/round-21-one-input.md" \
  "$collab_dir/round-21-one-input.html" \
  "JCA Round 21: When the Premise Can Test the Output"

build_html \
  "$collab_dir/round-22-ground-tests.md" \
  "$collab_dir/round-22-ground-tests.html" \
  "JCA Round 22: Testing an Output against a Ground Tree"

build_html \
  "$collab_dir/round-23-two-rigid.md" \
  "$collab_dir/round-23-two-rigid.html" \
  "JCA Round 23: Two Rigid Equations Fit in Two Ordinary Branches"

build_html \
  "$collab_dir/round-24-two-branches.md" \
  "$collab_dir/round-24-two-branches.html" \
  "JCA Round 24: Two Ordinary Branches Are Undecidable"

build_html \
  "$collab_dir/round-25-binary.md" \
  "$collab_dir/round-25-binary.html" \
  "JCA Round 25: The Exact Branch Threshold over One Binary Constructor and One Constant"

build_html \
  "$collab_dir/round-26-fixed-template.md" \
  "$collab_dir/round-26-fixed-template.html" \
  "JCA Round 26: A Fixed Pair of Implications Can Recognize a Machine Language"

build_html \
  "$collab_dir/round-27-joint-pins.md" \
  "$collab_dir/round-27-joint-pins.html" \
  "JCA Round 27: A Conclusion Can Bound the Search for an Output Strategy"

build_html \
  "$collab_dir/round-28-compression.md" \
  "$collab_dir/round-28-compression.html" \
  "JCA Round 28: Every Successful One-Branch Strategy Has a Bounded Witness"

build_html \
  "$collab_dir/round-29-small-dags.md" \
  "$collab_dir/round-29-small-dags.html" \
  "JCA Round 29: One Quantified Branch Has Polynomial-Size Certificates"

build_html \
  "$collab_dir/round-30-monadic.md" \
  "$collab_dir/round-30-monadic.html" \
  "JCA Round 30: One Quantified Implication Is NP-Complete on Every Nontrivial Signature"

build_html \
  "$collab_dir/round-31-leading.md" \
  "$collab_dir/round-31-leading.html" \
  "JCA Round 31: One Branch with Designated Variables and Leading Fresh Parameters"

build_html \
  "$collab_dir/round-32-carriers.md" \
  "$collab_dir/round-32-carriers.html" \
  "JCA Round 32: What a Designated Witness Can Read Through Another Move"

build_html \
  "$collab_dir/round-33-carrier-reduction.md" \
  "$collab_dir/round-33-carrier-reduction.html" \
  "JCA Round 33: One Branch and One Restricted Carrier Can Test a Proof Twice"

build_html \
  "$collab_dir/round-34-one-read.md" \
  "$collab_dir/round-34-one-read.html" \
  "JCA Round 34: Removing One Permitted Read Makes One Branch Undecidable"

build_html \
  "$collab_dir/round-35-required-example.md" \
  "$collab_dir/round-35-required-example.html" \
  "JCA Round 35: One Required Example, Partial or Fully Specified"

build_html \
  "$collab_dir/round-36-linear-examples.md" \
  "$collab_dir/round-36-linear-examples.html" \
  "JCA Round 36: Independent Blanks versus One Repeated Blank"

build_html \
  "$collab_dir/round-37-comparable.md" \
  "$collab_dir/round-37-comparable.html" \
  "JCA Round 37: Polynomial Certificates for Arbitrary Weak Presentations"

build_html \
  "$collab_dir/round-38-weak-solved.md" \
  "$collab_dir/round-38-weak-solved.html" \
  "JCA Round 38: A Single Forbidden Read with Only the Weak Escape Test"

build_html \
  "$collab_dir/round-39-weak-conjunctions.md" \
  "$collab_dir/round-39-weak-conjunctions.html" \
  "JCA Round 39: One Forbidden Read for Arbitrary Weak Conjunctions"

build_html \
  "$collab_dir/round-40-reflexive.md" \
  "$collab_dir/round-40-reflexive.html" \
  "JCA Round 40: The Reflexive Escape Order with Prior Substituted Parameters"

build_html \
  "$collab_dir/round-41-monadic-reads.md" \
  "$collab_dir/round-41-monadic-reads.html" \
  "JCA Round 41: Checking a Monadic Answer with a Bounded Number of Exceptional Reads"

build_html \
  "$collab_dir/round-42-maximal.md" \
  "$collab_dir/round-42-maximal.html" \
  "JCA Round 42: Deciding and Maximizing Answers Above a Supplied Example"

build_html \
  "$collab_dir/round-43-infinite-maxima.md" \
  "$collab_dir/round-43-infinite-maxima.html" \
  "JCA Round 43: The Maximal Answers in Thesis Example 4.3"

build_html \
  "$collab_dir/round-44-common-witness.md" \
  "$collab_dir/round-44-common-witness.html" \
  "JCA Round 44: A Single Consistency Witness for All Branches"

build_html \
  "$collab_dir/round-45-tiling.md" \
  "$collab_dir/round-45-tiling.html" \
  "JCA Round 45: Tiling an Exponential Square Inside a Common Ground Row"

build_html \
  "$collab_dir/round-46-two-observations.md" \
  "$collab_dir/round-46-two-observations.html" \
  "JCA Round 46: Two Compatible Input-Only Implications are NEXP-complete"

build_html \
  "$collab_dir/round-47-nested.md" \
  "$collab_dir/round-47-nested.html" \
  "JCA Round 47: A Chain of Input Premises Admits a Polynomial Algorithm"

# Build all review files
build_html \
  "$collab_dir/thesis-review-1.md" \
  "$collab_dir/thesis-review-1.html" \
  "What a branch witnesses: revisiting the InvarGenT thesis"

build_html \
  "$collab_dir/thesis-review-2.md" \
  "$collab_dir/thesis-review-2.html" \
  "A complete combination theorem and the convergence of predicate inference"

build_html \
  "$collab_dir/thesis-review-3.md" \
  "$collab_dir/thesis-review-3.html" \
  "When the induction jump drops an inductive postcondition"

build_html \
  "$collab_dir/thesis-review-4.md" \
  "$collab_dir/thesis-review-4.html" \
  "What it takes to prove a min or max postcondition"

build_html \
  "$collab_dir/thesis-review-5.md" \
  "$collab_dir/thesis-review-5.html" \
  "The parameter an induction jump has to remember"

build_html \
  "$collab_dir/thesis-review-6.md" \
  "$collab_dir/thesis-review-6.html" \
  "How far can a recursive call move the cap?"

build_html \
  "$collab_dir/thesis-review-7.md" \
  "$collab_dir/thesis-review-7.html" \
  "Recovering a cap from two constructors"

build_html \
  "$collab_dir/thesis-review-8.md" \
  "$collab_dir/thesis-review-8.html" \
  "When both ends of a recursive result interval move"

build_html \
  "$collab_dir/thesis-review-9.md" \
  "$collab_dir/thesis-review-9.html" \
  "Extracting an input bound from a recursive caller"

build_html \
  "$collab_dir/thesis-review-10.md" \
  "$collab_dir/thesis-review-10.html" \
  "When can the induction jump reuse a failed guess?"

build_html \
  "$collab_dir/thesis-review-11.md" \
  "$collab_dir/thesis-review-11.html" \
  "Which calls can one convex recursive invariant cover?"

build_html \
  "$collab_dir/thesis-review-12.md" \
  "$collab_dir/thesis-review-12.html" \
  "When a recursive result stops being a pair of equal indices"

build_html \
  "$collab_dir/thesis-review-13.md" \
  "$collab_dir/thesis-review-13.html" \
  "Feeding a supplier’s result bounds back to the recursive input"

build_html \
  "$collab_dir/thesis-review-14.md" \
  "$collab_dir/thesis-review-14.html" \
  "What the induction jump loses when two supplier caps cross"

build_html \
  "$collab_dir/thesis-review-15.md" \
  "$collab_dir/thesis-review-15.html" \
  "Which rates must a recursive postcondition remember?"

build_html \
  "$collab_dir/thesis-review-16.md" \
  "$collab_dir/thesis-review-16.html" \
  "A recursive package that fails before the induction jump"

build_html \
  "$collab_dir/thesis-review-17.md" \
  "$collab_dir/thesis-review-17.html" \
  "Checking a caller after inferring the package it opens"

build_html \
  "$collab_dir/thesis-review-18.md" \
  "$collab_dir/thesis-review-18.html" \
  "Which caller observations can guide the induction jump?"

build_html \
  "$collab_dir/thesis-review-19.md" \
  "$collab_dir/thesis-review-19.html" \
  "Which result index should the induction jump keep?"

build_html \
  "$collab_dir/thesis-review-20.md" \
  "$collab_dir/thesis-review-20.html" \
  "When must a guarded call constrain an input type?"

build_html \
  "$collab_dir/thesis-review-21.md" \
  "$collab_dir/thesis-review-21.html" \
  "What happens to a recursive call behind an impossible guard?"

build_html \
  "$collab_dir/thesis-review-22.md" \
  "$collab_dir/thesis-review-22.html" \
  "When the guard needs a second recursive postcondition"

build_html \
  "$collab_dir/thesis-review-23.md" \
  "$collab_dir/thesis-review-23.html" \
  "When does a recursive package have a least postcondition?"

build_html \
  "$collab_dir/thesis-review-24.md" \
  "$collab_dir/thesis-review-24.html" \
  "Where the induction jump loses the state index"

build_html \
  "$collab_dir/thesis-review-25.md" \
  "$collab_dir/thesis-review-25.html" \
  "Two calls at the same state can need different package parameters"

build_html \
  "$collab_dir/thesis-review-26.md" \
  "$collab_dir/thesis-review-26.html" \
  "Which calls make a fixed postcondition usable?"

reviews_dir="$collab_dir/reviews"
if [[ -d "$reviews_dir" ]]; then
  for md_file in "$reviews_dir"/*.md; do
    if [[ -f "$md_file" ]]; then
      base_name="$(basename "$md_file" .md)"
      html_file="$reviews_dir/$base_name.html"
      title="Agent Collaboration Review: $base_name"
      build_html "$md_file" "$html_file" "$title"
    fi
  done
fi

echo "All agent-collab HTML files built successfully."
