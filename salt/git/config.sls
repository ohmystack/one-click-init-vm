{% from "common/map.jinja" import common with context %}

include:
  - git
  - vim

github.com:
  ssh_known_hosts:
    - present
    - user: {{ common.username }}
    - enc: ssh-rsa
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48

gitignore_global:
  file.managed:
    - name: {{ common.user_home }}/.gitignore_global
    - source: salt://git/files/gitignore_global

config_git:
  cmd.run:
    - name: |
        git config --global user.name "{{ salt['pillar.get']('git:username') }}"
        git config --global user.email "{{ salt['pillar.get']('git:email') }}"
        git config --global core.autocrlf false
        # Prevent "There was a problem with the editor 'vi'" error on MacOSX
        git config --global core.editor /usr/bin/vim
        git config --global color.ui true
        git config --global core.excludesfile '~/.gitignore_global'
    - user: {{ common.username }}
    - require:
      - pkg: vim
      - file: gitignore_global
