{ lib, config, pkgs, ... }:

# TODO: split basic graphical / etc

{

  imports = [
    ./i3.nix
    ./polybar.nix
    #./sway.nix 
    #./hyprland.nix 
  ];

  # Enable user fonts
  fonts.fontconfig.enable = true;

  qt = {
    enable = true;
    style = {
      package = [ pkgs.adwaita-qt pkgs.adwaita-qt6 ];
      name = "adwaita";
    };
    # platformTheme = "qt5ct";
  };

  home.packages = with pkgs; [
    # X11 / Xorg
    xorg.xmodmap
    xorg.xkill
    xorg.xev
    xclip
    xdotool
    libnotify
    redshift
    arandr
    autorandr

    # Terminal
    pkgs.kitty
    pkgs.alacritty
    pkgs.viu
    ## Download
    pkgs.yt-dlp

    # GUI Apps
    ## Editor
    pkgs.kate
    ## Browser
    pkgs.brave
    # Credentials / Secrets
    #pkgs.bitwarden
    #pkgs.keybase-gui
    ## Note-taking
    # pkgs.logseq  # bug https://github.com/NixOS/nixpkgs/pull/274180
    ## File Manager
    pkgs.pcmanfm
    pkgs.dolphin
    ## Communication
    pkgs.telegram-desktop
    pkgs.discord
    ## idk
    #pkgs.calibre
    #qbittorrent # disable because of the vulnerability
    ## Music
    pkgs.spotify
    ## Audio
    pkgs.gnome-sound-recorder
    ## Screencast
    pkgs.peek
    ## Image-editing
    pkgs.gimp
    #pkgs.krita
    ## Misc
    ## Tools
    speedcrunch
    ## Dev
    pkgs.vscode
    ## BTC
    pkgs.electrum

    ## AppImage
    appimage-run

    # Audio
    ## Pipewire
    pipewire
    wireplumber
    qpwgraph
    #pkgs.easyeffects
    ## Pulseaudio
    pulseaudio
    pavucontrol
    pulsemixer

    # Screen
    ## Brightness
    ddcutil
    ddcui

    # Network
    networkmanagerapplet
    networkmanager_dmenu

    # Credentials
    pkgs.seahorse

    # Input tools
    libinput

    # Tiling native apps
    imv
    mpv
    zathura

    # Fonts
    pkgs.liberation_ttf
    pkgs.dejavu_fonts
    pkgs.roboto
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-emoji
    ## Dev
    pkgs.inconsolata
    pkgs.inconsolata-nerdfont
    #pkgs.nerd-fonts.inconsolata
    #pkgs.iosevka
    pkgs.iosevka-comfy.comfy
    pkgs.iosevka-comfy.comfy-duo
    pkgs.iosevka-comfy.comfy-fixed
    pkgs.fira-code
    # (pkgs.nerdfonts.override { fonts = [ "Inconsolata" "Iosevka" "FiraCode" "DroidSansMono" "Noto" ]; })
    pkgs.font-awesome
  ];

  xsession = {
    # enable = true;

    profileExtra = ''
      ${
        lib.getBin pkgs.dbus
      }/bin/dbus-update-activation-environment --systemd --all
    '';

    initExtra = ''
      ${config.home.homeDirectory}/.nix-profile/bin/xmodmap ${config.home.homeDirectory}/.Xmodmap
    '';
  };

  # Xmodmap: CapsLock as Hyper key
  home.file.".Xmodmap".text = ''
    keycode 66 = Hyper_L

    clear lock
    clear mod3
    clear mod4

    add mod3 = Hyper_L
    add mod4 = Super_L Super_R
  '';

  # Autostart Terminal with ssh-add
  home.file."config/kitty/ssh-add-session.kitty".text = ''
    launch zsh -c 'ssh-add; $SHELL'
  '';

  # XDG User Dirs
  home.file = {
    ".config/user-dirs.dirs".text = ''
      XDG_DESKTOP_DIR="$HOME/desktop"
      XDG_DOWNLOAD_DIR="$HOME/downloads"
      XDG_TEMPLATES_DIR="$HOME/templates"
      XDG_PUBLICSHARE_DIR="$HOME/public"
      XDG_DOCUMENTS_DIR="$HOME/documents"
      XDG_MUSIC_DIR="$HOME/music"
      XDG_PICTURES_DIR="$HOME/pictures"
      XDG_VIDEOS_DIR="$HOME/videos"
    '';
  };

}
