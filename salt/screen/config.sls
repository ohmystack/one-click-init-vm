{% from "common/map.jinja" import common with context %}
{% from "linux-scripts/map.jinja" import linux_scripts with context %}

include:
  - linux-scripts

link_screenrc:
  file.symlink:
    - name: {{ common.user_home }}/.screenrc
    - target: {{ linux_scripts.clone_to }}/screen/screenrc
    - force: True
    - require:
      - git: ohmystack/linux-scripts
      - pkg: install_screen
