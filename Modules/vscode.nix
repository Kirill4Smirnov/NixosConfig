{
  inputs,
  pkgs,
  lib,
  ...
}: {
  hm = {
    # home.file.".vscode/argv.json".text = builtins.toJSON {
    #   enable-crash-reporter = false;
    #   password-store = "gnome-libsecret";
    # };

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;

      mutableExtensionsDir = false;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = let
        vm = inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}.vscode-marketplace;
      in [
        # Python
        vm.ms-python.python
        vm.ms-python.vscode-pylance
        vm.ms-python.mypy-type-checker
        vm.ms-python.black-formatter
        vm.ms-python.isort
        vm.njpwerner.autodocstring

        # Jupyter
        pkgs.vscode-extensions.ms-toolsai.jupyter
        pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
        vm.ms-toolsai.datawrangler

        # Other languages
        pkgs.vscode-extensions.ms-vscode.cpptools
        vm.jnoortheen.nix-ide
        vm.mechatroner.rainbow-csv
        vm.redhat.java
        vm.redhat.vscode-xml
        vm.redhat.vscode-yaml
        vm.rust-lang.rust-analyzer
        vm.tamasfe.even-better-toml
        vm.yzhang.markdown-all-in-one

        # Tools
        vm.editorconfig.editorconfig
        vm.mkhl.direnv
        vm.stkb.rewrap
        vm.tyriar.sort-lines
        vm.fill-labs.dependi
        vm.asvetliakov.vscode-neovim

        vm.GitHub.github-vscode-theme
      ];
      userSettings = {
        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.serverSettings" = {
          nixd = {
            formatting = {
              command = [(lib.getExe pkgs.nixpkgs-fmt)];
            };
            options = {
              nixos = {
                expr = "(builtins.getFlake \"/home/kenlog/Configuration\").nixosConfigurations.KenNix.options";
              };
            };
          };
        };
        # Rust
        "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        "rust-analyzer.check.command" = "clippy";

        # Python
        "python.analysis.autoImportCompletions" = true;

        "black-formatter.path" = ["${pkgs.black}/bin/black"];
        "python.formatting.provider" = "black";

        "python.languageServer" = "Pylance";

        "mypy-type-checker.args" = ["--disable-error-code=import-untyped"];
        "mypy-type-checker.severity" = {
          "error" = "Warning";
          "note" = "Information";
        };
        # "mypy-type-checker.path" = [ "${pkgs.mypy}/bin/mypy" ];

        "python.poetryPath" = "${pkgs.poetry}/bin/poetry";
        "python.venvPath" = "~/.cache/pypoetry/virtualenvs";

        "isort.path" = ["${pkgs.python3Packages.isort}/bin/isort"];

        "python.testing.pytestEnabled" = true;
        "python.testing.pytestPath" = "${pkgs.python3Packages.pytest}/bin/pytest";

        # "jupyter.themeMatplotlibPlots" = true;
        # "python.formatting.blackArgs" = ["-l120" "-tpy311"];

        # VCS
        "diffEditor.ignoreTrimWhitespace" = false;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

        # Fonts
        "editor.fontLigatures" = "'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga'";
        "editor.fontFamily" = "'Monaspace Neon', monospace";
        "terminal.integrated.fontFamily" = "MesloLGS NF";
        "editor.fontSize" = 18;

        # UI
        "window.zoomLevel" = 1.25;

        # Other
        "direnv.restart.automatic" = true;
        "editor.formatOnSave" = true;
        "editor.quickSuggestions".strings = true;
        "editor.tabCompletion" = "on";
        "editor.unicodeHighlight.allowedLocales".ru = true;
        "files.autoSave" = "afterDelay";
        "redhat.telemetry.enabled" = false;
        "sortLines.filterBlankLines" = true;
        "workbench.startupEditor" = "none";

        "zenMode.centerLayout": false; 
        "zenMode.hideLineNumbers": false;
      };
    };
  };

  programs.direnv.enable = true;
}
