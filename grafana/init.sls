{% from "grafana/map.jinja" import grafana with context %}

grafana_repo:
  pkgrepo.managed:
    - humanname: Grafana
    - name: deb https://packages.grafana.com/oss/deb stable main
    - file: /etc/apt/sources.list.d/grafana.list
    - key_url: https://packages.grafana.com/gpg.key
    - clean_file: true

grafana_pkg:
  pkg.installed:
    - name: grafana
    - require:
      - pkgrepo: grafana_repo

grafana_cfg:
  file.managed:
    - name: {{ grafana.config }}/grafana.ini
    - source: salt://grafana/grafana.ini.jinja
    - mode: 640
    - user: root
    - group: grafana
    - template: jinja
    - defaults:
        settings: {{ grafana.settings|json }}

grafana_service:
  service.running:
    - name: grafana-server
    - enable: True
    - watch:
      - file: grafana_cfg
    - require:
      - pkg: grafana
