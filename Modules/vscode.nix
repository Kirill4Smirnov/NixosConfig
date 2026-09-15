{
  inputs,
  pkgs,
  lib,
  ...
}: let
  codexModelCatalog = pkgs.runCommand "codex-model-catalog.json" {nativeBuildInputs = [pkgs.jq];} ''
    set -o pipefail
    ${lib.getExe pkgs.codex} debug models --bundled 2>/dev/null \
      | jq '
          .models[0] as $base
          | .models = [
              ($base
                | .slug = "gpt-6-astra"
                | .display_name = "GPT-6 Astra"
                | .description = "GPT-6 Astra via the configured model provider."
                | .priority = 0
                | .visibility = "list")
            ] + .models
        ' > "$out"
  '';

  codexForVscode = pkgs.writeShellScriptBin "codex" ''
    exec ${lib.getExe pkgs.codex} \
      -c 'model_catalog_json="${codexModelCatalog}"' \
      "$@"
  '';
in {
  imports = [
    ./python.nix
  ];

  nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];

  hm = {
    home.packages = [
      pkgs.poetry
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;

      mutableExtensionsDir = false;
      profiles.default.enableUpdateCheck = false;
      profiles.default.enableExtensionUpdateCheck = false;

      profiles.default.extensions = let
        vm = pkgs.vscode-marketplace;
      in [
        # Python
        vm.ms-python.python
        vm.ms-python.vscode-pylance
        vm.ms-python.mypy-type-checker
        vm.ms-python.isort
        vm.njpwerner.autodocstring
        vm.ms-python.autopep8
        vm.kevinrose.vsc-python-indent
        vm.james-yu.latex-workshop

        # Jupyter
        pkgs.vscode-extensions.ms-toolsai.jupyter
        pkgs.vscode-extensions.ms-toolsai.jupyter-renderers

        # Other languages
        vm.golang.go
        pkgs.vscode-extensions.ms-vscode.cpptools
        pkgs.vscode-extensions.ms-vscode.cmake-tools
        vm.twxs.cmake
        vm."13xforever".language-x86-64-assembly
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
        pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
        vm.openai.chatgpt
      ];
      profiles.default.userSettings = {
        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.serverSettings" = {
          nixd = {
            formatting = {
              command = ["${pkgs.alejandra}/bin/alejandra"];
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

        # CPP
        "C_Cpp.default.compilerPath" = "/run/current-system/sw/bin/clang++";
        "cmake.cmakePath" = "/run/current-system/sw/bin/cmake";

        #Golang
        "go.lintTool" = "golangci-lint";
        "go.lintFlags" = [
          "--path-mode=abs"
          "--fast-only"
        ];
        "go.formatTool" = "custom";
        "go.alternateTools" = {
          "customFormatter" = "golangci-lint";
        };
        "go.formatFlags" = [
          "fmt"
          "--stdin"
        ];

        # Python
        "python.analysis.autoImportCompletions" = true;

        "python.formatting.provider" = "autopep8";
        "python.editor.defaultFormatter" = "ms-python.autopep8";

        "python.languageServer" = "Pylance";

        "mypy-type-checker.args" = ["--disable-error-code=import-untyped"];
        "mypy-type-checker.severity" = {
          "error" = "Warning";
          "note" = "Information";
        };
        "python.defaultInterpreterPath" = "\${workspaceFolder}/.venv/bin/python";
        "python.terminal.activateEnvironment" = true;
        "python.venvFolders" = [
          ".venv"
        ];
        "jupyter.jupyterServerType" = "local";

        "isort.path" = ["${pkgs.python3Packages.isort}/bin/isort"];

        "python.testing.pytestEnabled" = true;
        "python.testing.pytestPath" = "${pkgs.python3Packages.pytest}/bin/pytest";

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
        "workbench.colorTheme" = "Dark High Contrast";
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        "workbench.editorAssociations" = {
          "*.md" = "vscode.markdown.preview.editor";
        };

        # Other
        "chatgpt.cliExecutable" = lib.getExe codexForVscode;
        "direnv.restart.automatic" = true;
        "editor.formatOnSave" = true;
        "editor.quickSuggestions".strings = true;
        "editor.tabCompletion" = "on";
        "editor.unicodeHighlight.allowedLocales".ru = true;
        "files.autoSave" = "afterDelay";
        "redhat.telemetry.enabled" = false;
        "sortLines.filterBlankLines" = true;
        "workbench.startupEditor" = "none";

        "zenMode.centerLayout" = false;
        "zenMode.hideLineNumbers" = false;
        "latex-workshop.view.pdf.invert" = 1;
        "latex-workshop.formatting.latex" = "latexindent";
      };
    };
  };

  programs.direnv.enable = true;
}
