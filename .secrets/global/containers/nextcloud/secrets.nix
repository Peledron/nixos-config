let
  users = (import ../../../identities.nix).users;
  systems = (import ../../../identities.nix).systems;
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  # the list tells agenix to encrypt the file with the specified public keys, each key will be able to decrypt the fil
  "nextcloud-DB-password.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "nextcloud-ADMIN-password.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "storage-share_sync-pengolodh_credentials.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
}
