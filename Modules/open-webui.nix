{pkgs, ...}: {
  services.open-webui = {
    package = pkgs.open-webui;
    enable = true;
    port = 8085;
    environment = {
      HOME = "/var/lib/open-webui";
    };
  };
}
