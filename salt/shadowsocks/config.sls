include:
  - supervisor
  - supervisor.config
  - shadowsocks

shadowsocks.conf:
  file.managed:
    - name: /etc/shadowsocks.conf
    - source: salt://shadowsocks/files/shadowsocks.conf
    - template: jinja
    - context:
      shadowsocks_port: {{ salt['pillar.get']('shadowsocks:port', 1089) }}
      shadowsocks_passwd: {{ pillar['shadowsocks']['password'] }}
      shadowsocks_workers: {{ salt['pillar.get']('shadowsocks:workers', 1) }}
    - require:
      - pip: shadowsocks

supervisor_shadowsocks_config:
  file.managed:
    - name: /etc/supervisor/conf.d/shadowsocks.conf
    - mode: 644
  ini.options_present:
    - name: /etc/supervisor/conf.d/shadowsocks.conf
    - sections:
        program:shadowsocks:
          command: "ssserver -c /etc/shadowsocks.conf"
          autorestart: "true"
          user: "nobody"
    - require:
      - pkg: supervisor
      - sls: supervisor.config
      - file: supervisor_shadowsocks_config

{% if salt['pillar.get']('shadowsocks:optimize_sysctl', False) %}
optimizing_shadowsocks:
  file.managed:
    - name: /etc/sysctl.d/for_shadowsocks.conf
  ini.options_present:
    - name: /etc/sysctl.d/for_shadowsocks.conf
    - sections:
        DEFAULT_IMPLICIT:
          # max open files
          fs.file-max: 51200
          # max read buffer
          net.core.rmem_max: 67108864
          # max write buffer
          net.core.wmem_max: 67108864
          # default read buffer
          net.core.rmem_default: 65536
          # default write buffer
          net.core.wmem_default: 65536
          # max processor input queue
          net.core.netdev_max_backlog: 4096
          # max backlog
          net.core.somaxconn: 4096
          # resist SYN flood attacks
          net.ipv4.tcp_syncookies: 1
          # reuse timewait sockets when safe
          net.ipv4.tcp_tw_reuse: 1
          # turn off fast timewait sockets recycling
          net.ipv4.tcp_tw_recycle: 0
          # short FIN timeout
          net.ipv4.tcp_fin_timeout: 30
          # short keepalive time
          net.ipv4.tcp_keepalive_time: 1200
          # outbound port range
          net.ipv4.ip_local_port_range: 10000 65000
          # max SYN backlog
          net.ipv4.tcp_max_syn_backlog: 4096
          # max timewait sockets held by system simultaneously
          net.ipv4.tcp_max_tw_buckets: 5000
          # turn on TCP Fast Open on both client and server side
          net.ipv4.tcp_fastopen: 3
          # TCP receive buffer
          net.ipv4.tcp_rmem: 4096 87380 67108864
          # TCP write buffer
          net.ipv4.tcp_wmem: 4096 65536 67108864
          # turn on path MTU discovery
          net.ipv4.tcp_mtu_probing: 1
          # for high-latency network, use hybla
          # for low-latency network, use cubic instead
          net.ipv4.tcp_congestion_control: hybla
    - require:
      - pip: shadowsocks
      - file: optimizing_shadowsocks

apply_optimization:
  cmd.run:
    - names:
      - sysctl --system
      - sysctl -p
    - onchanges:
      - ini: optimizing_shadowsocks
{% endif %}

restart_shadowsocks:
  supervisord.running:
    - name: shadowsocks
    - update: True
    - restart: True
    - listen:
      - file: shadowsocks.conf
      - ini: supervisor_shadowsocks_config
