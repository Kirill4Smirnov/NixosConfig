{
  pkgs,
  config,
  ...
}: {
  hm = {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'

        local config = wezterm.config_builder()

        enable_wayland = true
        config.front_end = "WebGpu"

        return config
      '';
    };
  };
}
