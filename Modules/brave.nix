{
  pkgs,
  config,
  ...
}: {
  hm = {
    programs.brave = {
      enable = true;
    };
  };
}
