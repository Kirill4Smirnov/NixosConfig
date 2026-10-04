{
  appimageTools,
  atk,
  cairo,
  fetchurl,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  keybinder3,
  lib,
  libayatana-appindicator,
  libepoxy,
  pango,
}: let
  pname = "flclash";
  version = "0.8.98";

  src = fetchurl {
    url = "https://github.com/chen08209/FlClash/releases/download/v${version}/FlClash-${version}-linux-amd64.AppImage";
    hash = "sha256-aIup81EoISbP3ABjxGn0ObglM0k32pOi3rtUr/Hd8w0=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraPkgs = pkgs: [
      atk
      cairo
      gdk-pixbuf
      glib
      gtk3
      harfbuzz
      keybinder3
      libayatana-appindicator
      libepoxy
      pango
    ];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/FlClash.desktop \
        $out/share/applications/flclash.desktop
      install -m 444 -D ${appimageContents}/FlClash.png \
        $out/share/icons/hicolor/512x512/apps/flclash.png

      substituteInPlace $out/share/applications/flclash.desktop \
        --replace-fail "Exec=LD_LIBRARY_PATH=usr/lib FlClash %u" "Exec=flclash %u" \
        --replace-fail "Icon=FlClash" "Icon=flclash"
    '';

    meta = {
      description = "Proxy client based on ClashMeta, simple and easy to use";
      homepage = "https://github.com/chen08209/FlClash";
      license = lib.licenses.gpl3Plus;
      mainProgram = "flclash";
      platforms = ["x86_64-linux"];
    };
  }
