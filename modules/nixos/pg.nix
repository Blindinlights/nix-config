{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    
    enableTCPIP = true;

    authentication = pkgs.lib.mkOverride 10 ''
      # type  database  user  address       method
      local   all       all                 peer
      host    all       all   127.0.0.1/32  scram-sha-256
      host    all       all   ::1/128       scram-sha-256
    '';
    ensureDatabases = [ "ironclaw" ];
    package = pkgs.postgresql_16.withPackages (p: [ p.pgvector ]);
    ensureUsers = [{ name = "blindinlights"; ensureDBOwnership = false; }];
    
    initialScript = pkgs.writeText "init-sql-script" ''
      \c template1
      CREATE EXTENSION IF NOT EXISTS vector;
    '';
  };
}
