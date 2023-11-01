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

Googling suggests the mounting should work when the distro is selected as default. It is also important to `wsl --shutdown`, otherwise the mounting problem doesn't get fixed, and I cannot connect to the distro from VS Code. For VSCode, [WSL tips](https://code.visualstudio.com/docs/remote/troubleshooting#_wsl-tips) mentions installing `wget` and `ca-certificates` is also required. Here I install a different distribution:

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

```
# useradd -m -U myusername
# passwd myusername
# groupadd sudo
# usermod -aG sudo myuser
# pacman -Sy sudo git vi wget ca-certificates
# visudo
# # uncomment the line staritng with: # %sudo
:wq
# cd /etc
# code wsl.conf
[user]
default=myuser
# # save and quit VS Code after entering the above
# exit
```

```PowerShell
PS C:\Users\lukst> wsl --terminate Archlinux
PS C:\Users\lukst> wsl
```

Now let's install GitHub CLI:

```bash
$ cd ~
$ export VERSION=`curl  "https://api.github.com/repos/cli/cli/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c2-`
$ wget https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.tar.gz
$ tar xvf gh_${VERSION}_linux_amd64.tar.gz
$ sudo cp gh_${VERSION}_linux_amd64/bin/gh /usr/local/bin/
```
