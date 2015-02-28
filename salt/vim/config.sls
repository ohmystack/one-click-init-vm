{% from "common/map.jinja" import common with context %}

include:
  - git
  - git.config
  - vim

python-pip:
  pkg.installed

ctags:
  pkg.installed:
    {% if grains['os_family'] == 'Debian' %}
    - name: exuberant-ctags
    {% endif %}

pep8:
  pkg.installed

pyflakes:
  pkg.installed

pylint:
  pkg.installed

python-rope:
  pkg.installed

install_nodejs:
  pkg.installed:
    - name: nodejs

install_npm:
  pkg.installed:
    - name: npm

ropevim:
  pip.installed:
    - require:
      - pkg: python-pip

ohmystack/python-vim:
  git.latest:
    - name: git@github.com:ohmystack/python-vim.git
    - target: {{ common.user_home }}/.vim
    - user: {{ common.username }}
    - identity: {{ common.ssh_identity }}
    - submodules: True
    - require:
      - pkg: git
      - ssh_known_hosts: github.com
      - pkg: vim
      - pkg: ctags
      - pkg: pep8
      - pkg: pyflakes
      - pkg: pylint
      - pkg: python-rope
      - pkg: nodejs
      - pkg: npm
      - pip: ropevim

link_vimrc:
  file.symlink:
    - name: {{ common.user_home }}/.vimrc
    - target: {{ common.user_home }}/.vim/vimrc
    - force: True
    - require:
      - git: ohmystack/python-vim
