Publishing a regular project:
- [opam's CONTRIBUTING](https://github.com/ocaml/opam-repository/blob/master/CONTRIBUTING.md): old version describes the full `dune-release` process.
- [opam's documentation on Publishing](https://opam.ocaml.org/doc/Packaging.html#Publishing) describes `opam publish` and the manual process.
- Kit-ty-kate's [release script](https://github.com/kit-ty-kate/ocaml-release-script/blob/main/release.sh) is a light-weight alternative to `dune-release` using `opam publish`.


Hacky check os/distribution name from opam:

```bash
$ opam var os
$ opam var os-family
$ opam var os-distribution
```

or check 

Packages (maybe) needed to debug opam-repository on a fresh OS:
`gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash`

Installing opam and the opam-debug switch:

```bash
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
$ opam init
$ opam switch create opam-debug-5.1 --repos debug-opam="./opam-repository" 5.1.0
```

Startup a (sub)project:

```bash
$ opam install ocaml-lsp-server
$ opam install . --deps-only
$ dune build
$ dune install
```
