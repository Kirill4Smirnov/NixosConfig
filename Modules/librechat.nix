{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.librechatDocker;
  composeFile = pkgs.writeText "librechat-compose.yaml" ''
    services:
      api:
        container_name: LibreChat
        image: registry.librechat.ai/danny-avila/librechat-dev:latest
        restart: unless-stopped
        user: "''${LIBRECHAT_UID}:''${LIBRECHAT_GID}"
        depends_on:
          - mongodb
          - rag_api
        ports:
          - "127.0.0.1:${toString cfg.port}:${toString cfg.port}"
        extra_hosts:
          - "host.docker.internal:host-gateway"
        env_file:
          - ${cfg.dataDir}/.env
        environment:
          HOST: 0.0.0.0
          PORT: "${toString cfg.port}"
          DOMAIN_CLIENT: http://localhost:${toString cfg.port}
          DOMAIN_SERVER: http://localhost:${toString cfg.port}
          MONGO_URI: mongodb://mongodb:27017/LibreChat
          MEILI_HOST: http://meilisearch:7700
          LIBRECHAT_TEMP_CREDENTIALS_PATH: /app/data/.env.temp
          RAG_PORT: "8000"
          RAG_API_URL: http://rag_api:8000
          NO_PROXY: localhost,127.0.0.1,::1,mongodb,meilisearch,rag_api,vectordb,host.docker.internal
          no_proxy: localhost,127.0.0.1,::1,mongodb,meilisearch,rag_api,vectordb,host.docker.internal
        volumes:
          - ${cfg.dataDir}/images:/app/client/public/images
          - ${cfg.dataDir}/uploads:/app/uploads
          - ${cfg.dataDir}/logs:/app/logs
          - ${cfg.dataDir}/skill:/app/skill
          - librechat-data:/app/data

      admin-panel:
        container_name: librechat-admin-panel
        image: registry.librechat.ai/clickhouse/librechat-admin-panel:latest
        restart: unless-stopped
        depends_on:
          - api
        ports:
          - "127.0.0.1:${toString cfg.adminPort}:3000"
        environment:
          PORT: "3000"
          SESSION_SECRET: "''${ADMIN_PANEL_SESSION_SECRET}"
          API_SERVER_URL: http://api:${toString cfg.port}
          VITE_API_BASE_URL: http://localhost:${toString cfg.port}
          SESSION_COOKIE_SECURE: "false"

      mongodb:
        container_name: librechat-mongodb
        image: mongo:8.0.20
        restart: unless-stopped
        user: "''${LIBRECHAT_UID}:''${LIBRECHAT_GID}"
        command: mongod --noauth
        volumes:
          - ${cfg.dataDir}/mongodb:/data/db

      meilisearch:
        container_name: librechat-meilisearch
        image: getmeili/meilisearch:v1.35.1
        restart: unless-stopped
        user: "''${LIBRECHAT_UID}:''${LIBRECHAT_GID}"
        environment:
          MEILI_NO_ANALYTICS: "true"
          MEILI_MASTER_KEY: "''${MEILI_MASTER_KEY}"
        volumes:
          - ${cfg.dataDir}/meilisearch:/meili_data

      vectordb:
        container_name: librechat-vectordb
        image: pgvector/pgvector:0.8.0-pg15-trixie
        restart: unless-stopped
        environment:
          POSTGRES_DB: mydatabase
          POSTGRES_USER: myuser
          POSTGRES_PASSWORD: mypassword
        volumes:
          - librechat-pgdata:/var/lib/postgresql/data

      rag_api:
        container_name: librechat-rag-api
        image: registry.librechat.ai/danny-avila/librechat-rag-api-dev-lite:latest
        restart: unless-stopped
        depends_on:
          - vectordb
        env_file:
          - ${cfg.dataDir}/.env
        environment:
          DB_HOST: vectordb
          RAG_PORT: "8000"

    volumes:
      librechat-data:
        name: librechat-data
      librechat-pgdata:
        name: librechat-pgdata
  '';
in {
  options.services.librechatDocker = {
    enable = lib.mkEnableOption "LibreChat's official Docker Compose stack";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3080;
      description = "Local TCP port for LibreChat.";
    };

    adminPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Local TCP port for the LibreChat admin panel.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/librechat";
      description = "Persistent state directory for LibreChat.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "kenlog";
      description = "Host user that owns LibreChat's bind-mounted data.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0700 root root -"
    ];

    systemd.services.librechat = {
      description = "LibreChat Docker Compose stack";
      wantedBy = ["multi-user.target"];
      after = [
        "docker.service"
        "network-online.target"
      ];
      wants = ["network-online.target"];
      requires = ["docker.service"];

      path = [
        pkgs.coreutils
        pkgs.docker-compose
        pkgs.gnugrep
        pkgs.openssl
        pkgs.gnused
      ];

      preStart = ''
        install -d -m 0700 ${cfg.dataDir}
        install -d -o ${cfg.user} -g users -m 0750 \
          ${cfg.dataDir}/images \
          ${cfg.dataDir}/uploads \
          ${cfg.dataDir}/logs \
          ${cfg.dataDir}/skill \
          ${cfg.dataDir}/mongodb \
          ${cfg.dataDir}/meilisearch

        librechat_env=${cfg.dataDir}/.env
        touch "$librechat_env"
        chmod 0600 "$librechat_env"

        ensure_default() {
          librechat_key="$1"
          librechat_value="$2"
          if ! grep -q "^$librechat_key=" "$librechat_env"; then
            printf '%s=%s\n' "$librechat_key" "$librechat_value" >> "$librechat_env"
          fi
        }

        ensure_secret() {
          librechat_key="$1"
          librechat_bytes="$2"
          if ! grep -q "^$librechat_key=[^[:space:]].*" "$librechat_env"; then
            sed -i "/^$librechat_key=/d" "$librechat_env"
            printf '%s=%s\n' "$librechat_key" "$(openssl rand -hex "$librechat_bytes")" >> "$librechat_env"
          fi
        }

        ensure_default HOST 0.0.0.0
        ensure_default PORT ${toString cfg.port}
        ensure_default DOMAIN_CLIENT http://localhost:${toString cfg.port}
        ensure_default DOMAIN_SERVER http://localhost:${toString cfg.port}
        ensure_default NO_INDEX true
        ensure_default SEARCH true
        ensure_default MEILI_NO_ANALYTICS true
        ensure_default ALLOW_EMAIL_LOGIN true
        ensure_default ALLOW_REGISTRATION true
        ensure_default ALLOW_SOCIAL_LOGIN false
        ensure_default ALLOW_SOCIAL_REGISTRATION false
        ensure_default OPENAI_API_KEY user_provided
        ensure_default ANTHROPIC_API_KEY user_provided
        ensure_default ASSISTANTS_API_KEY user_provided

        ensure_secret CREDS_KEY 32
        ensure_secret CREDS_IV 16
        ensure_secret JWT_SECRET 32
        ensure_secret JWT_REFRESH_SECRET 32
        ensure_secret MEILI_MASTER_KEY 32
        ensure_secret ADMIN_PANEL_SESSION_SECRET 32
      '';

      script = ''
        export LIBRECHAT_UID="$(id -u ${cfg.user})"
        export LIBRECHAT_GID="$(id -g ${cfg.user})"
        docker-compose \
          --project-name librechat \
          --env-file ${cfg.dataDir}/.env \
          --file ${composeFile} \
          up --detach --remove-orphans
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutStartSec = "infinity";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose --project-name librechat --env-file ${cfg.dataDir}/.env --file ${composeFile} down";
      };
    };
  };
}
