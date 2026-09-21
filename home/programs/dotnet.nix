#    _  ___          _  ____________
#   / |/ (_)_ __    / |/ / __/_  __/
#  /    / /\ \ / _ /    / _/  / /
# /_/|_/_//_\_\ (_)_/|_/___/ /_/
# ----------------------------------
# .NET nix home package by lPhiNix
#
{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    dotnet-sdk_9 # .NET 9 SDK (C#/F#/VB)
    omnisharp-roslyn # C#/.NET language server
  ];

  # Quiet first runs (no telemetry/banner) and keep the NuGet package cache under XDG.
  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
    NUGET_PACKAGES = "${config.home.homeDirectory}/.cache/NuGet";
  };
}
