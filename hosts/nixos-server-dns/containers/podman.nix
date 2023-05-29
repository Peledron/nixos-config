
  /*
  virtualisation.oci-containers.containers = {
    grafana = {
      autoStart = true;
      workdir = "/home/pengolodh/nixos-config/hosts/nixos-server-dns/containers/container_data/grafana";
      #image: grafana/grafana:9.3.6
      image = "grafana/grafana:latest";
      #dependsOn = [ "influxdb" ];
      ports = ["127.0.0.1:3000:3000"];
      volumes = [
        "./data:/var/lib/grafana"
        "./config/provisioning/dashboards:/etc/grafana/provisioning/dashboards:ro"
        "./config/provisioning/datasources:/etc/grafana/provisioning/datasources:ro"
      ];
      environment = {
        #GF_SECURITY_ADMIN_USER = "${ADMIN_USER:-admin}";
        #GF_SECURITY_ADMIN_PASSWORD = "${ADMIN_PASSWORD:-admin}";
        GF_USERS_ALLOW_SIGN_UP = "false";
        GF_INSTALL_PLUGINS = "flant-statusmap-panel,grafana-piechart-panel";
        #GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH = "/etc/grafana/provisioning/dashboards/mikrotik/monitor.json";
      };
      extraOptions = [
        #"--network=host"
        #''--mount=type=volume,source=grafana,target=/var/lib/grafana,volume-driver=local,volume-opt=type=nfs,volume-opt=device=:/containers/grafana_data,"volume-opt=o=addr=10.10.0.12,rw,nfsvers=4.0,nolock,hard,noatime"''
      ];
    };
  };
  */