{
  lib,
  pkgs,
  inputs,
  binaryCaches,
  ...
}: let
  username = "kenlog";
  hostName = "KenNix";
  flakePath = "/home/kenlog/Configuration";
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-486bb194-339e-47d8-bb1e-0b9b1aaf2a32".device = "/dev/disk/by-uuid/486bb194-339e-47d8-bb1e-0b9b1aaf2a32";

  networking.hostName = hostName;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.extraLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
  ];

  hardware.graphics.enable = true;

  nixpkgs.config.allowUnfree = true;

  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = username;
      };
    };

    desktopManager.gnome.enable = true;

    printing.enable = true;

    libinput.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings.hosts = [
      "unix:///var/run/docker.sock"
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.nushell;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 40d";
  };

  nix.settings = {
    accept-flake-config = true;
    download-attempts = binaryCaches.download-attempts;
    fallback = binaryCaches.fallback;
    stalled-download-timeout = binaryCaches.stalled-download-timeout;
    substituters = lib.mkForce binaryCaches.substituters;
    trusted-public-keys = lib.mkForce binaryCaches.trusted-public-keys;
  };

  programs.partition-manager.enable = true;
  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    flake = flakePath;
  };

  hm.programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      {package = vitals;}
      {package = power-off-options;}
      {package = blur-my-shell;}
    ];
  };

  hm.dconf.settings."org/gnome/desktop/sound".event-sounds = false;

  environment = {
    systemPackages = with pkgs; let
      # TODO: remove after nixpkgs packages a Tauon release containing the
      # corrected desktop entry from upstream.
      tauonFixed = tauon.overrideAttrs (old: {
        postInstall =
          (old.postInstall or "")
          + ''
            substituteInPlace "$out/share/applications/tauonmb.desktop" \
              --replace-fail "Exec=tauonmb %U" "Exec=tauon %U"
          '';
      });

      base = [
        amneziawg-go
        amneziawg-tools
        vim
        wget
        poppler-utils
      ];

      systemTools = [
        inxi
        htop
        pciutils
        bind
      ];

      devTools = [
        qemu
        go
        golangci-lint
        rustup
        clang-tools
        clang
        cmake
        ninja
        gnumake
        android-tools
        uv
      ];

      desktopApps = [
        gimp
        gnome-tweaks
        gnome-themes-extra
        power-profiles-daemon
        ayugram-desktop
        signal-desktop
        keepassxc
        obs-studio
        rnote
        libreoffice
        texliveFull
        kdePackages.okular
        vlc
        endeavour
        docker-compose
        obsidian
        inputs.flclash-nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.flclash
        tauonFixed
        codex
        opencode
      ];

      cliNice = [
        fzf
        git
        fastfetch
        alejandra
        eza
        ncdu
        dust
        neovim
        pipes-rs
        cmatrix
        btop
        p7zip
        libGL
        unrar
        asciinema
        ripgrep
        ripgrep-all
      ];
    in
      base
      ++ systemTools
      ++ devTools
      ++ desktopApps
      ++ cliNice;

    variables.EDITOR = "nvim";
    extraOutputsToInstall = [
      "dev"
    ];
    sessionVariables = {
      GDK_DISABLE = "gles-api";
      LIBGL_DEBUG = "verbose";
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
