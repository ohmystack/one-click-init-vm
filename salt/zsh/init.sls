{% from "common/map.jinja" import common with context %}
{% from "linux-scripts/map.jinja" import linux_scripts with context %}

include:
  - git
  - linux-scripts

remove_ohmyzsh_config:
  file.absent:
    - name: {{ common.user_home }}/.oh-my-zsh/

install_zsh:
  pkg.installed:
    - name: zsh
    - require:
      - file: remove_ohmyzsh_config

set_default_shell:
  cmd.run:
    - name: chsh -s `which zsh` {{ common.username }}
    - shell: /bin/bash
    - require:
      - pkg: install_zsh

robbyrussell/oh-my-zsh:
  git.latest:
    - name: git://github.com/robbyrussell/oh-my-zsh.git
    - target: {{ common.user_home }}/.oh-my-zsh
    - user: {{ common.username }}
    - identity: {{ common.ssh_identity }}
    - submodules: True
    - require:
      - pkg: git
      - ssh_known_hosts: github.com
      - pkg: install_zsh
      - cmd: set_default_shell
