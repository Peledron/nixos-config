let
  users = (import ../../../identities.nix).users;
  systems = (import ../../../identities.nix).systems;
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  # the list tells agenix to encrypt the file with the specified public keys, each key will be able to decrypt the fil
  "librenms_COMMON_env.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "librenms_MARIADB_env.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "librenms_LIBRENMS_env.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "librenms_MSMTPD_env.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "librenms_DISPATCHER_env.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "librenms_SYSLOGNG_env.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
  "librenms_SNMPTRAPD_env.age".publicKeys = [users.pengolodh systems.nixos-server-hp];
}
