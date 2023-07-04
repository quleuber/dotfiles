{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix tools
    direnv
    nix-direnv
    nix-index
    nixos-option
    nixfmt
    nixpkgs-fmt
    dhall
    home-manager

    ## App Image
    appimage-run

    # Essential
    curl
    wget
    rsync
    openssh
    git

    # Terminal / Shell tools
    fzf
    stow
    silver-searcher
    ripgrep
    diff-so-fancy
    shellcheck
    ## File utilities
    file
    exa
    tree
    ncdu
    nnn
    broot
    ranger
    bat
    unzip
    ## Misc
    httpie
    jq
    jc
    tmux
    tmate

    # System utilities
    htop
    pstree
    lsof
    iotop
    pciutils
    usbutils
    ## Network utilities
    inetutils
    nmap
    dig

    # Secrets
    gnupg
    age
    inputs.agenix.packages.${pkgs.system}.agenix
    git-crypt
    libsecret

    # Shell
    zoxide

    # Editors
    vim
    helix

    # Utilities
    pdftk

    # Dev
    ## Git
    tig
    gh
    gita
    ## Package managers
    yarn
    nodejs
    ## Language managers
    rustup
    #haskellPackages.ghcup

    python310
    python310Packages.ipython
  ];
}