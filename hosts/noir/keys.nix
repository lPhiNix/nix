#    _  __     _       __ __
#   / |/ /__  (_)___  / //_/__ __ _____
#  /    / _ \/ / __/ / ,< / -_) // (_-<
# /_/|_/\___/_/_/   /_/|_|\__/\_, /___/
#                            /___/
# -------------------------------------
# Noir authorized SSH keys by lPhiNix
#
# authorizedKeys is the list of public keys allowed to log in as the primary
# user on THIS host; the matching private keys are stored encrypted by the
# secrets capability. Mesh: every host trusts every host's user key, so any
# machine can SSH into any other. The trailing '@noir'/'@blizz' is only a
# label; the key blob is what authenticates.
#
{config, ...}: {
  users.users.${config.myConfig.username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5u3hCEEc7yx7wqEBUZjGMLnNfli4VMs2Dhzl8PFzvr phinix@noir" # public half of noir's user key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDayb7sHHMBtdv49ApB+ivY85Aod3luFtat9BUmUQ+6z phinix@blizz" # public half of blizz's user key
  ];
}
