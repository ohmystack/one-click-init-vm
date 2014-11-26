{% from "common/map.jinja" import common with context %}

nopasswd:
  file.append:
    - name: /etc/sudoers
    - text: |
        {{ common.username }} ALL=(ALL) NOPASSWD: ALL
