let
  pengolodh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2Ic51w68EFuVfoqvWo3xbZCYYyAdt2Mj4u6ZXh2pP"; #nixos-pengolodh.pub
  users = [pengolodh];
  
  nixos-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAayJn+auIYJ7p4doIjAZvLcSw33txsyZZ8fhWJiLS+K";
  nixos-server-hp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbY0X0Len/HM3Bkj2XiCg06dZ7BNXA1DkUKf1lHlgFL";
  systems = [nixos-main nixos-server-hp];
in {
  # the list tells agenix to encrypt the file with the specified public keys, each key will be able to decrypt the fil
  "librenms_database-password.age".publicKeys = [pengolodh] ++ [nixos-server-hp];
}