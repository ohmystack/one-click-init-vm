include:
  - pip

shadowsocks:
  pip.installed:
    - require:
      - pkg: python-pip

python-gevent:
  pkg.installed
