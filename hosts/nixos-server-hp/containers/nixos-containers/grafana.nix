{
  config,
  lib,
  pkgs,
  vlans,
  ...
}: let
  br_local_container_name = "br0cont";
  netport = "eth0";
in {
  containers.monitor = {
    autoStart = true;
    extraFlags = ["-U"]; # run as user instead of root
    privateNetwork = true;
    hostBridge = "${br_local_container_name}";
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      #environment.etc."resolv.conf".text = "nameserver 1.1.1.1";# resolv.conf cannot be shared with host

      services.resolved.enable = true;
      networking = {
        #useDHCP = lib.mkForce true;
        interfaces = {
          ${netport}.ipv4.addresses = [
            {
              address = "192.168.1.12";
              prefixLength = 24;
            }
          ];
          /*
          ${netport}.ipv6.addresses = [
            {
              address = "2a01:4f8:1c1b:16d0::1";
              prefixLength = 64;
            }
          ];
          */
        };
        defaultGateway = {
          address = "192.168.1.3";
          interface = "${netport}";
        };
        /*
        defaultGateway6 = {
          address = "fe80::1";
          interface = "${netport}";
        };
        */

        useNetworkd = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [80 443];
        };
        useHostResolvConf = lib.mkForce false;
      };

      #============#
      # nginx:
      #============#
      services.nginx = {
        enable = true;
        #recommendedProxySettings = true; # seems to counter the nginx settings needed to make grafana work
        recommendedOptimisation = true;
        recommendedGzipSettings = true;

        # from https://grafana.com/tutorials/run-grafana-behind-a-proxy/#configure-nginx
        commonHttpConfig = "
          map $http_upgrade $connection_upgrade {
            default upgrade;
            '' close;
          } 
        ";

        # from https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e
        upstreams = {
          "grafana" = {
            servers = {
              "127.0.0.1:${toString config.services.grafana.settings.server.http_port}" = {};
            };
          };
          "prometheus" = {
            servers = {
              "127.0.0.1:${toString config.services.prometheus.port}" = {};
            };
          };
          "loki" = {
            servers = {
              "127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}" = {};
            };
          };
          "promtail" = {
            servers = {
              "127.0.0.1:${toString config.services.promtail.configuration.server.http_listen_port}" = {};
            };
          };
        };

        # from https://grafana.com/tutorials/run-grafana-behind-a-proxy/#configure-nginx
        virtualHosts.grafana = {
          locations."/" = {
            proxyPass = "http://grafana";
            proxyWebsockets = true;

            extraConfig = "
              proxy_set_header Host $host;
            ";
          };
          locations."/api/live" = {
            proxyPass = "http://grafana";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $connection_upgrade;
              proxy_set_header Host $host;
            '';
          };
          /*
          listen = [{
            addr = "172.24.1.2";
            port = 8010;
          }];
          */
        };
      };
      # ---

      #============#
      # grafana:
      #============#
      services.grafana = {
        enable = true;

        settings = {
          disable_sanitize_html = true;
          analytics.reporting_enabled = false;
          server = {
            #rootUrl = "http://172.24.1.2:8010";
            domain = "grafana.home.pengolodh.be";
            http_port = 2342;
            http_addr = "127.0.0.1";
          };
        };

        provision.datasources.settings = {
          apiVersion = 1;
          datasources = [
            # prometheus
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
              editable = true;
              jsonData.graphiteVersion = "1.1";
            }

            # loki
            {
              name = "Loki";
              type = "loki";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
              #editable = true;
            }
          ];
        };
      };
      # ---

      #============#
      # prometheus:
      #============#
      # following this guide: https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20
      services.prometheus = {
        enable = true;
        port = 9090;
        globalConfig = {
          scrape_interval = "15s";
          evaluation_interval = "15s";
        };
        exporters = {
          node = {
            enable = true;
            enabledCollectors = ["systemd"];
            port = 9002;
          };
        };
        scrapeConfigs = [
          {
            job_name = "local_machine";
            static_configs = [
              {
                targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
              }
            ];
          }
          {
            job_name = "blocky";
            static_configs = [{targets = ["192.168.1.10:4000"];}];
          }
        ];
      };
      # ---

      #============#
      # loki:
      #============#
      # from https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e
      # loki: port 3030 (8030)
      #
      services.loki = {
        enable = false;
        configuration = {
          server.http_listen_port = 3030;
          auth_enabled = false;

          ingester = {
            lifecycler = {
              address = "127.0.0.1";
              ring = {
                kvstore = {
                  store = "inmemory";
                };
                replication_factor = 1;
              };
            };
            chunk_idle_period = "1h";
            max_chunk_age = "1h";
            chunk_target_size = 999999;
            chunk_retain_period = "30s";
            #max_transfer_retries = 0;
          };

          schema_config = {
            configs = [
              {
                from = "2022-06-06";
                store = "boltdb-shipper";
                object_store = "filesystem";
                schema = "v11";
                index = {
                  prefix = "index_";
                  period = "24h";
                };
              }
            ];
          };

          storage_config = {
            boltdb_shipper = {
              active_index_directory = "/var/lib/loki/boltdb-shipper-active";
              cache_location = "/var/lib/loki/boltdb-shipper-cache";
              cache_ttl = "24h";
              #shared_store = "filesystem";
            };

            filesystem = {
              directory = "/var/lib/loki/chunks";
            };
          };

          limits_config = {
            reject_old_samples = true;
            reject_old_samples_max_age = "168h";
          };

          #chunk_store_config = {
          #  max_look_back_period = "0s";
          #};

          table_manager = {
            retention_deletes_enabled = false;
            retention_period = "0s";
          };

          compactor = {
            working_directory = "/var/lib/loki";
            #shared_store = "filesystem";
            compactor_ring = {
              kvstore = {
                store = "inmemory";
              };
            };
          };
        };
        # user, group, dataDir, extraFlags, (configFile)
      };

      #============#
      # promtail:
      #============#
      # promtail: port 3031 (8031)
      #
      services.promtail = {
        enable = true;
        configuration = {
          server = {
            http_listen_port = 3031;
            grpc_listen_port = 0;
          };
          positions = {
            filename = "/tmp/positions.yaml";
          };
          clients = [
            {
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
            }
          ];
          scrape_configs = [
            {
              job_name = "journal";
              journal = {
                max_age = "12h";
                labels = {
                  job = "systemd-journal";
                  host = "nixos-server-dns";
                };
              };
              relabel_configs = [
                {
                  source_labels = ["__journal__systemd_unit"];
                  target_label = "unit";
                }
              ];
            }
          ];
        };
        # extraFlags
      };

      system.stateVersion = "23.11";
    };
  };
}
