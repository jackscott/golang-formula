{% from "golang/map.jinja" import config with context %}
# :TODO: Move this shit into defaults

# pull down a copy of the archive the first time we run but check
# with the salt filesystem for a copy before hitting the web.
# regardless of source, they should all pass the hash check
golang|cache-archive:
  file.managed:
    - name: /tmp/{{ config.archive_name }}
    - source: https://storage.googleapis.com/golang/{{ config.archive_name }}
    - source_hash: sha256={{ config.archive_hash }}
    - user: root
    - group: root
    - unless:
        - test -f /tmp/{{ config.archive_name }}

# Extract the archive locally to {{ config.base_dir }}/go
# which is useful if we ever need to handle multiple versions
golang|extract-archive:
  file.directory:
    - names:
        - {{ config.base_dir }}
    - user: root
    - group: root
    - mode: 775
    - makedirs: true
    - recurse:
        - user
        - group
        - mode
  # golang|cache-archive provides us with a cached copy of the archive
  # so we only need to look in a single place when we actually exract
  # if the version of go is already installed and is on our path, skip extract
  archive.extracted:
    - name: {{ config.base_dir }}
    - source: "/tmp/{{ config.archive_name }}"
    - source_hash: sha256={{ config.archive_hash }}
    - archive_format: tar
    - user: root
    - group: root
    - tar_options: v
    - require:
        - file: golang|cache-archive
    - unless:
        - go version | grep {{ config.version }}
        - test -x {{ config.base_dir }}/go/bin/go

# add a symlink from versioned install to /usr/local/go
golang|update-alternatives:
  alternatives.install:
    - name: golang-home-link
    - link: {{ config.go_root }}
    - path: {{ config.base_dir }}/go/
    - priority: 31
    - order: 10
    - watch:
        - archive: golang|extract-archive

# add symlinks to /usr/bin for the three go commands
{% for i in ['go', 'godoc', 'gofmt'] %}
golang|create-symlink-{{ i }}:
  alternatives.install:
    - name: link-{{ i }}
    - link: /usr/bin/{{ i }}
    - path: {{ config.go_root }}/bin/{{ i }}
    - priority: 40
    - order: 10
    - watch:
        - archive: golang|extract-archive
{% endfor %}

golang|setup-bash-profile:
  file.managed:
    - name: /etc/profile.d/golang.sh
    - source:
        - salt://files/go_profile.sh
        - salt://golang/files/go_profile.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    
