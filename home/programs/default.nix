{...}: {
  # Aggregates the per-program home-manager modules.
  imports = [
    ./git.nix
    ./java.nix
    ./python.nix
    ./rust.nix
    ./cc.nix
    ./go.nix
    ./dotnet.nix
    ./lua.nix
    ./kotlin.nix
    ./node.nix
    ./android.nix
  ];
}
