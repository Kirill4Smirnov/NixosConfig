{...}: {
  hm = {
    programs = {
      carapace.enable = true;
      carapace.enableNushellIntegration = true;

      yazi = {
        enable = true;
        enableNushellIntegration = true;
      };

      starship = {
        enable = true;
        settings = {
          add_newline = true;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
      };
    };
  };
}
