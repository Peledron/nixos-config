let
  pengolodh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2Ic51w68EFuVfoqvWo3xbZCYYyAdt2Mj4u6ZXh2pP"; #nixos-pengolodh.pub

  nixos-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAayJn+auIYJ7p4doIjAZvLcSw33txsyZZ8fhWJiLS+K";
  nixos-server-hp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbY0X0Len/HM3Bkj2XiCg06dZ7BNXA1DkUKf1lHlgFL";
  systems = [nixos-main nixos-server-hp];
in {
  "password.age".publicKeys = [pengolodh] ++ systems; # the list tells agenix to encrypt the file with the specified public keys
}
