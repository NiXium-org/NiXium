# !!! WORK IN PROGRESS !!!
* UN-SUITABLE AND UN-STABLE FOR MISSION CRITICAL **AND/OR** PRODUCTION ENVIRONMENT

---

# NiXium (N/X)

Nix-based Open-Source Infrastructure as Code (OSS IaaC) Management Solution for Multiple Systems.

## Install

You can have a look at the available flake outputs before getting started.

```console
$ nix flake show github:gvolpe/nix-config
github:gvolpe/nix-config/7cddf7540c3e1eff34ee52eddd5416e972902d6b
├───homeConfigurations: unknown
├───nixosConfigurations
│   ├───dell-xps: NixOS configuration
│   ├───edp-tongfang-amd: NixOS configuration
│   └───tongfang-amd: NixOS configuration
└───packages
    └───x86_64-linux
        ├───metals: package 'metals-1.0.0'
        └───metals-updater: package 'metals-updater-script'
```

As well as all the declared flake inputs.

```console
$ nix flake metadata github:gvolpe/nix-config
```

The `edp-tongfang-amd` configuration also contains my Home Manager configuration using the NixOS module, so it can easily be tested with a single command.

```console
$ nixos-rebuild switch --flake github:gvolpe/nix-config#edp-tongfang-amd
```

Or you can test it directly on a QEMU virtual machine, though it has its limitations in terms of graphics.

```console
$ nixos-rebuild build-vm --flake github:gvolpe/nix-config#edp-tongfang-amd
./result/bin/run-tongfang-amd-vm
```

Having both NixOS and Home Manager configurations combined makes it easier to quickly install it on a new machine, but my preference is to have both separate, as my Home Manager configuration changes more often than that of the NixOS one, resulting in multiple generations at boot time.

Managing the different Home Manager generations in isolation makes this way easier for me.

### NixOS

The NixOS configuration can be installed by running the following command.

```console
$ nixos-rebuild switch --flake github:gvolpe/nix-config#tongfang-amd
```

Beware that the `hardware-configuration.nix` file is the result of the hardware scan of the specific machine and might not be suitable for yours.

### Home Manager

A fresh install requires the creation of certain directories (see what the `build` script does). However, if you omit those steps, the entire HM configuration can also be built as any other flake.

```console
$ nix build github:gvolpe/nix-config#homeConfigurations.gvolpe-edp.activationPackage
$ result/activate
```

### Full configuration via script

On a fresh NixOS installation, run the following commands.

```console
$ nix flake clone github:gvolpe/nix-config --dest /choose/a/path
$ ./build fresh-install # requires sudo
```

There's an additional step required if you want to have secrets working.

```console
$ nix run nixpkgs#git-crypt unlock
```

> NOTE: it requires your GPG Keys to be correctly set up.

The `build` script is only suitable for a fresh install customized to my personal use but you can build the flakes directly. E.g.

```console
$ nix build .#nixosConfigurations.tongfang-amd.config.system.build.toplevel
sudo result/bin/switch-to-configuration switch
```

Or for Home Manager.

```console
$ nix build .#homeConfigurations.gvolpe-hdmi.activationPackage
$ result/activate
```

# Development dependencies

To contribute and help with development you will need the following:

* `nix` (required) - Access standardized development environment and interact with the project
  * Configured with `nix-command` (required) - Legacy commands are too unreliable in this evironment
  * Feature `flakes` enabled (required) - Uses flakes for everything
* `direnv` (optional) - Get the development environment applied automatically when you enter the directory

# Design

Start from `flake.nix` (see [Flakes](https://nixos.wiki/wiki/Flakes)). [`flake-parts`](https://flake.parts/) is used as the module system.

## Directory layout

```
.
├── build
├── flake.nix
├── flake.lock
├── switch
├── home
│  ├── daemon.conf
│  ├── home.nix
│  ├── modules
│  ├── overlays
│  ├── programs
│  ├── scripts
│  ├── secrets
│  ├── services
│  └── themes
├── imgs
├── lib
│  ├── default.nix
│  ├── overlays.nix
├── notes
├── outputs
│  ├── home-conf.nix
│  ├── home-module.nix
│  └── nixos-conf.nix
└── system
   ├── configuration.nix
   ├── fonts
   ├── machine
   ├── misc
   └── wm
```

- `nixos`: nixos modules for Linux
- `users`: user information
- `machines`: top-level management for various systems

# References
## Manuals
* [home-manager's options](https://nix-community.github.io/home-manager/options.html)

## Guides
* [NixOS Flakes Wiki](https://nixos.wiki/wiki/Flakes)
* [Nix Flakes, Part 3: Managing NixOS systems - Eelco Dolstra](https://www.tweag.io/blog/2020-07-31-nixos-flakes/)
* [NixOS Configuration with Flakes - jordanisaacs](https://jdisaacs.com/series/nixos-desktop/)
* [The working programmer’s guide to setting up Haskell projects - jonascarpay](https://jonascarpay.com/posts/2021-01-28-haskell-project-template.html)
* [Shell Scripts with Nix - Jon Sangster](https://ertt.ca/nix/shell-scripts/)
* [OpenSSH security and hardening - Linux Audit](https://linux-audit.com/audit-and-harden-your-ssh-configuration)
* [sshd_config - How to configure the OpenSSH server - www.ssh.com](https://www.ssh.com/academy/ssh/sshd_config)
* [openssh - mozilla](https://infosec.mozilla.org/guidelines/openssh.html)
* [Arch security wiki](https://wiki.archlinux.org/title/security)
* [Arch openssh wiki](https://wiki.archlinux.org/title/OpenSSH)
* [Ask for a password in POSIX-compliant shell? - stackexchange](https://unix.stackexchange.com/questions/222974/ask-for-a-password-in-posix-compliant-shell)
* [Shell Stlye Guide - google](https://google.github.io/styleguide/shellguide.html)
* [Parameter Expansion - The Open Group Base Specifications Issue](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02)
* [Here Documents](https://linux.die.net/abs-guide/here-docs.html)
* [getopt, getopts or manual parsing - what to use when I want to support both short and long options?](https://unix.stackexchange.com/questions/62950/getopt-getopts-or-manual-parsing-what-to-use-when-i-want-to-support-both-shor)
* [How to autorebase MRs in GitLab CI - Marcin Wosinek](https://how-to.dev/how-to-autorebase-mrs-in-gitlab-ci)
* https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/

## NixOS Configs

Collection of NixOS configurations that you might find useful as a reference for your configuration:

* [Mic92's dotfiles repo](https://github.com/Mic92/dotfiles)
* [jordanisaacs's dotfiles repo](https://github.com/jordanisaacs/dotfiles)
* [jordanisaacs's dwm repo](https://github.com/jordanisaacs/dwm-flake)
* https://github.com/gvolpe/nix-config
* https://github.com/divnix/digga
* https://github.com/mitchellh/nixos-config
* https://codeberg.org/matthew/nixdot
* https://github.com/terlar/nix-config
* https://github.com/qbit/xin
* https://github.com/mrjones2014/dotfiles
* https://git.sr.ht/~x4d6165/nix-configuration
* https://github.com/TLATER/dotfiles
* https://gitlab.com/engmark/root
* https://codeberg.org/samuelsung/nixos-config (flake-parts)
* https://github.com/srid/nixos-config (flake-parts)
* https://github.com/Mic92/dotfiles (flake-parts)
* https://github.com/chvp/nixos-config
* https://github.com/NickCao/flakes (agenix)
* https://github.com/ocfox/den (agenix)
* https://github.com/Clansty/flake (flakes + deploy-rs)
* https://github.com/fufexan/dotfiles (flakes + agenix + flake-parts + home-manager)
* https://github.com/gvolpe/nix-config
* https://github.com/cole-h/nixos-config (flakes + agenix)
* https://github.com/moni-dz/nix-config (flakes + flake-parts + agenix + home-manager + darwin)
* https://github.com/vkleen/machines

Relevant GitHub Topic: https://github.com/topics/nixos-configuration

https://github.com/search?q=flake.homeManagerModules&type=code

GitHub repositories which use flake-parts: https://github.com/search?q=flake-parts+path%3Aflake.nix&type=code&p=3

## Projects
* [flake-compat](https://github.com/edolstra/flake-compat)
* [sops-nix](https://github.com/Mic92/sops-nix)
* [NixOS hardware repo](https://github.com/NixOS/nixos-hardware)
* [update-flake-lock](https://github.com/DeterminateSystems/update-flake-lock)
* [arkenfox's user.js](https://github.com/arkenfox/user.js)
* [de956's browser-privacy](https://github.com/de956/browser-privacy)
* https://github.com/redcode-labs/RedNixOS

## Tips

- To update NixOS (and other inputs) run `nix flake update`
  - You may also update a subset of inputs, e.g.
      ```sh
      nix flake lock --update-input nixpkgs --update-input home-manager
      # Or, `nix run .#update`
      ```
- To free up disk space,
    ```sh-session
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +2
    sudo nixos-rebuild boot
    ```
- To autoformat the project tree using nixpkgs-fmt, run `nix fmt`.
- To build all flake outputs (locally or in CI), run `nix run nixpkgs#nixci`

# Windows is Malware

Due to Windows being [filled with an overwhelming amount of various malware](https://www.gnu.org/proprietary/malware-microsoft.html) it's not supported by nix and neither by this. ReactOS maybe?
