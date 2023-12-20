# Notes on contributing to the main opam repository

## Debugging opam repository changes with a local repository

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
`gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash gh unzip bzip2`

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
$ opam switch create opam-debug-5.1 --repos debug-opam="./opam-repository" ocaml.5.1.1
```

Startup a (sub)project:

```bash
$ opam install ocaml-lsp-server
$ opam install . --deps-only
$ dune build
$ dune install
```

## Releasing a new project version

[The high-level tutorial on publishing packages](https://ocaml.org/docs/publishing-packages-w-dune). The instructions on contributing to the opam repository [using `dune-release`](https://github.com/ocaml/opam-repository/blob/master/CONTRIBUTING.md) and [using `opam publish`](https://opam.ocaml.org/doc/Packaging.html).

There are two helpers when it comes to releasing a new version of a project on opam.ocaml.org:

- [`opam publish`](https://github.com/ocaml-opam/opam-publish) is minimalistic.
- [`dune-release`](https://github.com/tarides/dune-release) has more features and is more opinionated. It will eventually be upstreamed as a `dune release` command.

I'm publishing ppx_minidebug 0.6.1. The `dune-release` process did not work for me.

First, it insisted on creating a tag with a hash suffix, ppx_minidebug 0.6.1-1-g38691fd, which was refused, although it had already created a tag 0.6.1.

With `dune-release publish -t 0.6.1`, I got:

```sh
[-] Creating release 0.6.1 on https://github.com/lukstafi/ppx_minidebug.git via github's API
dune-release: [ERROR] Github API error:
    Could not retrieve release ID from response
    Github API returned: "Bad credentials"
```

This is despite `gh api --method GET` examples working for me.

Okay, maybe better luck with `opam publish`. As suggested, I create a GitHub release manually (reusing the `0.6.1` tag).

Very nice that the `opam publish` plugin auto-installs, also with the system dependencies.

Note: when asked for token, make sure to paste it just once, as on my terminal it was silent.

This apparently succeeded (only failed at the end to open a browser, this seems to not be configured in my not-well-configured WSL distro).

Note: `dune-release publish` pushed documentation changes to `gh-pages`, but that did not update the [landing page](https://lukstafi.github.io/ppx_minidebug/index.html)'s library version -- it seems it's better when I use my custom target `dune build @upload-doc`.
