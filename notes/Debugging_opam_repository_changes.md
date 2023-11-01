Hacky check os/distribution name from opam:

```opam
build: [
  ["sh" "-exc" "echo os %{os}% family %{os-family}% distrib %{os-distribution}% ; abort"]
]
```

Packages (maybe) needed to debug opam-repository on a fresh OS:
`gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash`

Installing opam and the opam-debug switch:

```bash
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
$ opam init
$ opam switch create opam-debug-5.1 --repos debug-opam="./opam-repository" 5.1.0
```
