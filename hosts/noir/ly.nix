#    _  __     _       __
#   / |/ /__  (_)___  / /  __ __
#  /    / _ \/ / __/ / /__/ // /
# /_/|_/\___/_/_/   /____/\_, /
#                        /___/
# ----------------------------------------------
# Noir ly (display manager) nix theme by lPhiNix
#
{...}: let
  # VGA/PuTTY default 16-colour palette, with bright-black (#8) darkened
  # from 555555 to 1a1a1a. The VT kernel collapses dark neutrals to
  # bright-black, so this is what makes the colormix animation read
  # near-black on the VT instead of the default grey.
  vgaPalette = [
    "000000"
    "aa0000"
    "00aa00"
    "aa5500"
    "0000aa"
    "aa00aa"
    "00aaaa"
    "aaaaaa"
    "1a1a1a"
    "ff5555"
    "55ff55"
    "ffff55"
    "5555ff"
    "ff55ff"
    "55ffff"
    "ffffff"
  ];
in {
  services.displayManager.ly.settings = {
    # Palette
    bg = "0x000a0f0f";
    fg = "0x00dce8e6";
    border_fg = "0x009bd0cc";
    error_fg = "0x01fa746f";

    # Card
    blank_box = true;
    box_title = "caelestia";
    text_in_center = true;

    # Clocks
    bigclock = "en";
    bigclock_12hr = false;
    clock = "%a %H:%M";

    # Hidden info
    hide_version_string = true;
    hide_key_hints = true;
    hide_keyboard_locks = true;

    # Battery / input
    battery_id = "BAT0";
    clear_password = true;

    # Colormix animation: the VT kernel collapses dark neutrals to
    # bright-black (palette #8, darkened above), so col1 is true black
    # and col2/col3 near-black.
    animation = "colormix";
    cmatrix_fg = "0x006d7876";
    cmatrix_head_col = "0x00a2adac";
    colormix_col1 = "0x20000000";
    colormix_col2 = "0x00010101";
    colormix_col3 = "0x00020202";
  };

  # Apply the palette above to the virtual console.
  console.colors = vgaPalette;
}
