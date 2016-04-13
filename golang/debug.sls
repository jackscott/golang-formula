{% from "golang/map.jinja" import config with context %}

golang|debugin:
  file.managed:
    - name: /tmp/golang-formula.log
    - contents: |
        {% for k,v in config.items() %}
        {{ k }} => {{ v }}
        {% endfor %}
