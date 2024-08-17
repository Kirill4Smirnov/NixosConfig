{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  kver = config.boot.kernelPackages.kernel.version; # variable not used at the moment
in {

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "amd_pstate=active"
    "resume_offset=533760"
  ];

  boot.extraModulePackages = [config.boot.kernelPackages.lenovo-legion-module];

  networking.hostName = "KenNix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  networking.firewall.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs = {
      root = {
        SUBVOLUME = "/@";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "0";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
        BACKGROUND_COMPARISON = "yes";
        NUMBER_CLEANUP = "no";
        NUMBER_MIN_AGE = "1800";
        NUMBER_LIMIT = "50";
        NUMBER_LIMIT_IMPORTANT = "10";
        EMPTY_PRE_POST_CLEANUP = "yes";
        EMPTY_PRE_POST_MIN_AGE = "1800";
      };
      home = {
        SUBVOLUME = "/@home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "2";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
        BACKGROUND_COMPARISON = "yes";
        NUMBER_CLEANUP = "no";
        NUMBER_MIN_AGE = "1800";
        NUMBER_LIMIT = "50";
        NUMBER_LIMIT_IMPORTANT = "10";
        EMPTY_PRE_POST_CLEANUP = "yes";
        EMPTY_PRE_POST_MIN_AGE = "1800";
      };
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;
  # this trick with predicate wasn't working (the packages weren't been installed)
  #nixpkgs.config.allowUnfreePredicate = pkg:
  #  builtins.elem (lib.getName pkg) [
  #    "obsidian"
  #    "zoom-us"
  #  ];

  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kenlog = {
    isNormalUser = true;
    extraGroups = ["wheel" "input" "networkmanager"]; # Enable ‘sudo’ for the user.
    shell = pkgs.nushell;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    vim
    wget
    #firefox
    lenovo-legion
    linuxKernel.packages.linux_zen.lenovo-legion-module

    inxi
    htop
    pciutils
    nushell
    gimp
    wezterm
    gparted
    yazi
    gnome.gnome-tweaks
    gnomeExtensions.vitals
    gnomeExtensions.hibernate-status-button
    keepassxc
    gnome-extension-manager
    power-profiles-daemon
    telegram-desktop
    timeshift
    fzf
    git
    neofetch
    obs-studio
    alejandra
    rnote
    eza
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    bottles
    tribler

    obsidian
    zoom-us
    mathematica

    # nvidia-x11
    # nvidia-settings
    # nvidia-persistenced
  ];

  environment.variables.EDITOR = "vim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  swapDevices = [
    {
      device = "/.swapvol/swapfile";
      size = 26 * 1024;
    }
  ];
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  boot.resumeDevice = "/dev/mapper/crypted";
}
