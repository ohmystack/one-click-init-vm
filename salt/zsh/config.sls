{% from "common/map.jinja" import common with context %}
{% from "linux-scripts/map.jinja" import linux_scripts with context %}

include:
  - linux-scripts

autojump:
  pkg.installed

add_my_theme:
  file.copy:
    - name: {{ common.user_home }}/.oh-my-zsh/themes/
    - source: {{ linux_scripts.clone_to }}/zsh/themes/af-magic-custom.zsh-theme
    - force: True
    - subdir: True
    - makedirs: True
    - require:
      - git: ohmystack/linux-scripts
      - git: robbyrussell/oh-my-zsh

link_zshrc:
  file.symlink:
    - name: {{ common.user_home }}/.zshrc
    - target: {{ linux_scripts.clone_to }}/zsh/zshrc
    - force: True
    - require:
      - git: ohmystack/linux-scripts
      - git: robbyrussell/oh-my-zsh
      - pkg: autojump
      - file: add_my_theme
