{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.transmission = {
    enable = true;
    openRPCPort = true;
    settings = {
      # Override default settings
      rpc-bind-address = "0.0.0.0"; # Bind to own IP
      rpc-whitelist = "127.0.0.1,10.0.0.1,100.80.54.57,100.122.118.24"; # Whitelist your remote machine (10.0.0.1 in this example)
      rpc-host-whitelist-enabled = false;
    };
  };
}
