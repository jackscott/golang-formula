{% from "golang/map.jinja" import golang with context %}

golang|debugin:
  file.managed:
    - name: /tmp/golang-formula.log
    - contents: |
        {% for k,v in golang.items() %}
        {{ k }} => {{ v }}
        {% endfor %}
