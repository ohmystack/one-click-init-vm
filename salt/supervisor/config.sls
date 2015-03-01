include:
  - supervisor

supervisord.conf:
  ini.options_present:
    - name: /etc/supervisor/supervisord.conf
    - sections:
      unix_http_server:
        file: /tmp/supervisor.sock
        chmod: 0766
      include:
        files: /etc/supervisor/conf.d/*.conf
    - require:
      - pkg: supervisor

supervisor/conf.d:
  file.directory:
    - name: /etc/supervisor/conf.d
    - require:
      - pkg: supervisor

restart_supervisord:
  service.running:
    - name: supervisor
    - listen:
      - ini: supervisord.conf
      - file: supervisor/conf.d
