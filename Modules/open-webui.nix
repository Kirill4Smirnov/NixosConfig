{...}: {
  services.open-webui = {
    enable = true;
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
