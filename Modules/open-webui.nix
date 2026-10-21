{pkgs, ...}: let
  open-webui-fixed = pkgs.open-webui.overridePythonAttrs (_old: {
    # make-shell-wrapper now expects each wrapper argument separately.
    makeWrapperArgs = [
      "--set"
      "FRONTEND_BUILD_DIR"
      "${pkgs.open-webui.frontend}/share/open-webui"
    ];
  });
in {
  services.open-webui = {
    enable = true;
    package = open-webui-fixed;
    host = "127.0.0.1";
    port = 8085;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      CORS_ALLOW_ORIGIN = "http://localhost:8085;http://127.0.0.1:8085";
      DO_NOT_TRACK = "True";
      ENABLE_SIGNUP = "True";
      SCARF_NO_ANALYTICS = "True";
      USER_AGENT = "Open-WebUI/0.11.1";
      WEBUI_AUTH = "True";
    };
    openFirewall = false;
  };
}
