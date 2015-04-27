include:
  - pip

shadowsocks:
  pip.installed:
    - require:
      - cmd: python-pip

python-gevent:
  pkg.installed
