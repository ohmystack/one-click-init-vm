{% from "common/map.jinja" import common with context %}

create_user:
  user.present:
    - name: {{ common.username }}
    - home: /home/{{ common.username }}
    - password: {{ common.userpasswd_hash }}
    - enforce_password: False
