# Debugging opam repository changes with a local repository

Publishing a regular project:

- [opam's CONTRIBUTING](https://github.com/ocaml/opam-repository/blob/master/CONTRIBUTING.md): old version describes the full `dune-release` process.
- [opam's documentation on Publishing](https://opam.ocaml.org/doc/Packaging.html#Publishing) describes `opam publish` and the manual process.
- Kit-ty-kate's [release script](https://github.com/kit-ty-kate/ocaml-release-script/blob/main/release.sh) is a light-weight alternative to `dune-release` using `opam publish`.

Check os/distribution/version from opam among other things: `$ opam var`
Also a hacky way to find "once-for-all" the CI targets:

```opam
  ["sh" "-exc" "echo os %{os}% family %{os-family}% distrib %{os-distribution}% ver %{os-version} ; abort"]
```

Packages (maybe) needed to debug opam-repository on a fresh OS:
`gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash gh unzip`

To [install them on an unsupported Ubuntu](https://medium.com/enekochan/install-software-in-unsupported-ubuntu-versions-with-apt-get-ea9b5bd18d2) version:

```bash
$ sudo sed -i -e 's/archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
$ sudo apt-get update
```

Installing opam and the opam-debug switch:

```bash
$ gh auth login
$ gh repo clone lukstafi/opam-repository
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
