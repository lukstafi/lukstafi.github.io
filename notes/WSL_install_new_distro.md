# How to update or install a new Linux distribution on WSL

It's easiest if the distribution is available in the Microsoft Store:
[How to install Linux on Windows with WSL](https://learn.microsoft.com/en-gb/windows/wsl/install)
Since it will help me debug `opam-repository` distributions, let's start by installing some of MS Store distros.

```PowerShell
PS C:\Users\lukst> wsl --list --online
The following is a list of valid distributions that can be installed.
Install using 'wsl --install -d <Distro>'.

NAME                                   FRIENDLY NAME
Ubuntu                                 Ubuntu
Debian                                 Debian GNU/Linux
kali-linux                             Kali Linux Rolling
Ubuntu-18.04                           Ubuntu 18.04 LTS
Ubuntu-20.04                           Ubuntu 20.04 LTS
Ubuntu-22.04                           Ubuntu 22.04 LTS
OracleLinux_7_9                        Oracle Linux 7.9
OracleLinux_8_7                        Oracle Linux 8.7
OracleLinux_9_1                        Oracle Linux 9.1
openSUSE-Leap-15.5                     openSUSE Leap 15.5
SUSE-Linux-Enterprise-Server-15-SP4    SUSE Linux Enterprise Server 15 SP4
SUSE-Linux-Enterprise-15-SP5           SUSE Linux Enterprise 15 SP5
openSUSE-Tumbleweed                    openSUSE Tumbleweed
PS C:\Users\lukst> wsl --install -d Debian
Installing: Debian GNU/Linux
Debian GNU/Linux has been installed.
Launching Debian GNU/Linux...
PS C:\Users\lukst>
```

In my current setup, this failed to mount the Windows disk:

```bash
[17385.384063] init: (1) ERROR: MountPlan9WithRetry:285: mount drvfs on /mnt/c (cache=mmap,noatime,msize=262144,trans=virtio,aname=drvfs;path=C:\;uid=0;gid=0;symlinkroot=/mnt/
[17385.384064] ) failed: 16
```

Googling suggests the mounting should work when the distro is selected as default. It is also important to `wsl --shutdown`, otherwise the mounting problem doesn't get fixed, and I cannot connect to the distro from VS Code.

P.S. Maybe, `wsl --terminate -d Debian` would suffice. Selecting as default does not seem to be needed. Even when `code .` does not start VS Code, opening a new VS Code window and selecting "Connect to..." and then "Connect to WSL using distro..." works.

For VSCode, [WSL tips](https://code.visualstudio.com/docs/remote/troubleshooting#_wsl-tips) mentions installing `wget` and `ca-certificates` is also required. Here I install a different distribution:

```PowerShell
PS C:\Users\lukst> wsl --unregister Ubuntu
Unregistering...
PS C:\Users\lukst> wsl --install -d OracleLinux_9_1
PS C:\Users\lukst> wsl -s OracleLinux_9_1
PS C:\Users\lukst> wsl --list --all
Windows Subsystem for Linux Distributions:
OracleLinux_9_1 (Default)
openSUSE-Tumbleweed
Debian
PS C:\Users\lukst> wsl
$ sudo yum install ca-certificates
PS C:\Users\lukst> wsl --shutdown
PS C:\Users\lukst> wsl
```

Now, `$ code .` works.

OracleLinux does not have the GitHub CLI in the repository, I used [this tutorial](https://computingforgeeks.com/how-to-install-github-cli-on-linux-and-windows/?expand_article=1) to install it.

I had Ubuntu-22.10 installed. It is past its shell life, therefore I couldn't update it from within. Otherwise I could do:

```bash
$ sudo apt update & sudo apt upgrade
$ sudo emacs -nw /etc/update-manager/release-upgrades
# Change [DEFAULT] to [normal]
$ sudo apt remove snapd
$ sudo do-release-upgrade
Checking for a new Ubuntu release
Your Ubuntu release is not supported anymore.
```

The official tutorial to manually install distributions: [Import any Linux distribution to use with WSL](https://github.com/MicrosoftDocs/WSL/blob/main/WSL/use-custom-distro.md). [This introduction](https://dev.to/milolav/manually-installing-wsl2-distributions-41b4) is more to the point.

After wasting some time on other approaches, I [downloaded Alpine from here](https://github.com/alpinelinux/docker-alpine/blob/e7f8cc3aebd309337497c1e794db9aabbb9902c0/x86_64/alpine-minirootfs-3.18.4-x86_64.tar.gz), unpacked `.tar.gz` -> `.tar` via Git bash, and installed:

```bash
lukst@lukstafi-legion MINGW64 ~
$ gzip -d Downloads/alpine-minirootfs-3.18.4-x86_64.tar.gz
```

(Turns out the unpacking step is actually redundant, you can just use `.tar.gz` directly below.)

```PowerShell
PS C:\Users\lukst> mkdir WSL\Alpine
PS C:\Users\lukst> wsl --import Alpine .\WSL\Alpine .\Downloads\alpine-minirootfs-3.18.4-x86_64.tar
PS C:\Users\lukst> wsl -s Alpine
PS C:\Users\lukst> wsl --shutdown
PS C:\Users\lukst> wsl
```

Now I [download Archlinux from here](https://gitlab.archlinux.org/archlinux/archlinux-docker/-/package_files/5238/download) and:

```PowerShell
PS C:\Users\lukst> wsl --shutdown
PS C:\Users\lukst> mkdir WSL\Archlinux
PS C:\Users\lukst> wsl --import Archlinux .\WSL\Archlinux .\Downloads\base-20231029.0.188123.tar
PS C:\Users\lukst> wsl -s Archlinux
PS C:\Users\lukst> wsl
```

Now I add my user -- this is not automated as it is with distros packaged for WSL. I also install packages, needed sooner or later.

```sh
# useradd -m -U myusername
# passwd myusername
# groupadd sudo
# usermod -aG sudo myuser
# pacman -Sy sudo git vi wget ca-certificates
# visudo
# # uncomment the line staritng with: # %sudo
:wq
# (echo [user]; echo default=lukstafi) >& /etc/wsl.conf
# exit
```

```PowerShell
PS C:\Users\lukst> wsl --terminate Archlinux
PS C:\Users\lukst> wsl
```

Now let's install GitHub CLI:

```sh
$ cd ~
$ export VERSION=`curl  "https://api.github.com/repos/cli/cli/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c2-`
$ wget https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.tar.gz
$ tar xvf gh_${VERSION}_linux_amd64.tar.gz
$ sudo cp gh_${VERSION}_linux_amd64/bin/gh /usr/local/bin/
```

Let's come back to Alpine and add the user.

```PowerShell
PS C:\Users\lukst> wsl -d Alpine
# apk add adduser
# sudo adduser -g "My User" myuser
# apk add curl wget ca-certificates sudo
# addgroup sudo
# adduser lukstafi sudo
# visudo
# # uncomment the line staritng with: # %sudo
:wq
# (echo [user]; echo default=lukstafi) >& /etc/wsl.conf
# exit
PS C:\Users\lukst> wsl --terminate Alpine
PS C:\Users\lukst> wsl -d Alpine
```

## Some more distro sources

I downloaded [Debian Trixie i.e. 13 from here](https://github.com/debuerreotype/docker-debian-artifacts/blob/feccbb81c63226a8bf2e38315fc025a91fdd95dc/trixie/rootfs.tar.xz).
Then: `wsl --import Debian_Trixie .\WSL\debian_trixie .\Downloads\debian-trixie-rootfs.tar.xz`

Unfortunately this way of installing Trixie gives a poor terminal experience. Also, `opam` cannot infer the `os-version`.

There is [a whole project dedicated to NixOS on WSL](https://github.com/nix-community/NixOS-WSL), I downloaded [nixos-wsl.tar.gz](https://github.com/nix-community/NixOS-WSL/releases/download/23.5.5.2/nixos-wsl.tar.gz), then ([this tutorial / configuration](https://github.com/LGUG2Z/nixos-wsl-starter) was helpful):

```shell
> wsl --import NixOS .\WSL\NixOS\ .\Downloads\nixos-wsl.tar.gz --version 2
> wsl -d NixOS
$ sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
```

Installing [Linux Mint for WSL2](https://github.com/sileshn/LinuxmintWSL2) is very easy, because SileshN's project has its own [Windows installer](https://github.com/sileshn/LinuxmintWSL2/releases) (archived together with the `rootfs.tar.gz` image). Then just: `wsl -d Mint`, it will interactively setup a new user. But the installer will not let you install multiple versions of Mint, so to install another parallel version you can [download an older release](https://github.com/sileshn/LinuxmintWSL2/releases), unpack it, and use `wsl --import` as above.

## Installing FreeBSD via NomadBSD on a USB stick

I followed the installation instructions on [nomadbsd.org](https://www.nomadbsd.org/download.html). Then I needed to disable _Secure Boot_ in BIOS. You can get to BIOS settings by maybe pressing F2 on startup, or via _Windows / Settings / Windows Update / Advanced Options / Recovery / Advanced startup: Restart now_. Then I needed to disable auto-detection of graphics in NomadBSD: press 7 on startup for settings, then 6, (then 7 for verbose logging,) then 1, then 1. If the computer turns off at this moment, repeat this again (the settings are not saved).

The default shell of NomadBSD was hanging for me, fortunately entering `bash` resolved this!

## Package managers

Packages to install:

* Debian, Ubuntu: `sudo apt-get install gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash unzip bzip2 gh`

To [install them on an unsupported Ubuntu](https://medium.com/enekochan/install-software-in-unsupported-ubuntu-versions-with-apt-get-ea9b5bd18d2) version:

```bash
$ sudo sed -i -e 's/archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
$ sudo apt-get update
```

* Arch: `sudo pacman -Sy gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash unzip`
* Alpine: `sudo apk add gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash unzip`
* OracleLinux: `sudo yum install gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash unzip`
* openSUSE: `sudo zypper in gcc make patch bubblewrap diffutils rsync curl wget git ca-certificates bash unzip`
* NixOS:

```shell
nix-shell -p gcc
nix-shell -p gnumake
nix-shell -p patch
nix-shell -p bubblewrap
nix-shell -p diffutils
nix-shell -p rsync
nix-shell -p curl
nix-shell -p wget
nix-shell -p git
nix-shell -p cacert
nix-shell -p bash
nix-shell -p unzip
```

* FreeBSD: `sudo pkg install gcc gmake patch diffutils rsync curl wget git bash unzip`
