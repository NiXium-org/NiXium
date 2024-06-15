# NiXium (N/X)

Nix-based Open-Source Infrastructure as Code (OSS IaaC) Management Solution for Multiple Systems designed to be reliable tool for mission-critical tasks in paranoid and high-security environment. It uses [disko](https://github.com/nix-community/disko) for filesystem management, [impermanence](https://github.com/nix-community/impermanence) to enforce fully declarative setup, [flake-parts](https://github.com/hercules-ci/flake-parts) for flakes and [home-manager](https://github.com/nix-community/home-manager) for user configuration.

## Directory layout
...

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
* https://github.com/wimpysworld/nix-config
* https://github.com/gvolpe/nix-config


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
* https://xeiaso.net/blog/paranoid-nixos-2021-07-18

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