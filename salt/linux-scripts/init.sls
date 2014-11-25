{% from "common/map.jinja" import common with context %}
{% from "linux-scripts/map.jinja" import linux_scripts with context %}

include:
  - git

ohmystack/linux-scripts:
  git.latest:
    - name: git@github.com:ohmystack/linux-scripts.git
    - target: {{ linux_scripts.clone_to }}
    - user: {{ common.username }}
    - identity: {{ common.ssh_identity }}
    - submodules: True
    - require:
      - pkg: git
      - ssh_known_hosts: github.com
