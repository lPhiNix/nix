#    _  ___        ___
#   / |/ (_)_ __  / _ \___ _  __
#  /    / /\ \ / / // / -_) |/ /
# /_/|_/_//_\_\ /____/\__/|___/
# --------------------------------
# Dev nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim # Cli IDE

    # LazyVim lives in an isolated profile: NVIM_APPNAME=lazyvim nvim
    (writeShellScriptBin "lazyvim" ''
      exec env NVIM_APPNAME=lazyvim ${pkgs.neovim}/bin/nvim "$@"
    '')

    # Neovim / LazyVim tooling (LSPs managed by Nix, not Mason)
    tree-sitter # Parser builder used by nvim-treesitter (CLI)

    vscode-langservers-extracted # jsonls (JSON LSP)
    yaml-language-server # yamlls (YAML LSP)
    taplo # TOML LSP and formatter
    nil # Nix LSP
    nixfmt # Nix formatter
    statix # Nix linter

    opencode # Cli local/remote AI coding client

    direnv # Environments vars loader
  ];
}
