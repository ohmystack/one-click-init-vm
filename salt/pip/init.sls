python-pip:
  cmd.script:
    - name: https://bootstrap.pypa.io/get-pip.py
    - unless: which pip
