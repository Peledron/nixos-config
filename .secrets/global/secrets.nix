let
  users = (import ../../identities.nix).users;
  systems = (import ../../identities.nix).systems;
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  # the list tells agenix to encrypt the file with the specified public keys, each key will be able to decrypt the fil
  "rkvm-server_key.age".publicKeys = [systems.nixos-main];
  "rkvm-server_cert.age".publicKeys = [systems.nixos-main];
  #"rkvm-server_password.age".publicKeys = [systems.nixos-main]; # the password is not a file
  "mullvad-wireguard_private-key.age".publicKeys = [users.pengolodh systems.nixos-main];
}
