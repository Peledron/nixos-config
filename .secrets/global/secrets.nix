let
  users = {
    pengolodh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2Ic51w68EFuVfoqvWo3xbZCYYyAdt2Mj4u6ZXh2pP"; #nixos-pengolodh.pub
  };
  systems = {
    nixos-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAayJn+auIYJ7p4doIjAZvLcSw33txsyZZ8fhWJiLS+K";
    nixos-server-hp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbY0X0Len/HM3Bkj2XiCg06dZ7BNXA1DkUKf1lHlgFL";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  # the list tells agenix to encrypt the file with the specified public keys, each key will be able to decrypt the fil
  "librenms_database-password.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "technitium-dns-server_admin-password.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "rkvm-server_key.age".publicKeys = [systems.nixos-main];
  "rkvm-server_cert.age".publicKeys = [systems.nixos-main];
  #"rkvm-server_password.age".publicKeys = [systems.nixos-main]; # the password is not a file
  "mullvad-wireguard_private-key.age".publicKeys = [users.pengolodh systems.nixos-main];
}
