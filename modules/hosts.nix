{ config, lib, ... }:

{
  config = {
    networking.hosts = {
      "127.0.0.2" = [ "other-localhost" ];
      "192.0.2.1" = [ "mail.example.com" "imap.example.com" ];
    };
  };
}
