{% from "golang/map.jinja" import config with context %}
# Installing Golang is pretty easy, thanks Googs, so basically all we need to
# do is pull down an archive and unpack it somewhere.  To allow for versioning,
# we use a extract the tarball to <prefix>/golang/<version>/go and then create
# a symlink back to `golang:lookup:go_root` which defaults to /usr/local/go

# In the interest of being good netizens, we will only pull down the archive
# if golang is not installed or the specific version is missing
golang|cache-archive:
  file.managed:
    - name: /tmp/{{ config.archive_name }}
    - source: https://storage.googleapis.com/golang/{{ config.archive_name }}
    - source_hash: sha256={{ config.archive_hash }}
    - user: root
    - group: root
    - unless:
        # asserts go is on our path
        - which go
        # asserts the version of go
        - test -x {{ config.base_dir }}/go/bin/go
        

# Extract the archive locally to golang:lookup:base_dir: which has our version
# schema already baked in and extract the archive if necessary
golang|extract-archive:
  file.directory:
    - names:
        - {{ config.base_dir }}
        - {{ config.go_path }}
    - user: root
    - group: root
    - mode: 775
    - makedirs: truen
    - unless:
        - test -d {{ config.base_dir }}
    - recurse:
        - user
        - group
        - mode

  archive.extracted:
    - name: {{ config.base_dir }}
    - source: "/tmp/{{ config.archive_name }}"
    - source_hash: sha256={{ config.archive_hash }}
    - archive_format: tar
    - user: root
    - group: root
    - options: v
    - watch:
        - file: golang|cache-archive
    # golang|cache-archive already applies these predicates and the watch
    # statement should cover us, paranoia is an applied art.
    - unless:
        - go version | grep {{ config.version }}
        - test -x {{ config.base_dir }}/go/bin/go

# add a symlink from versioned install to point at golang:lookup:go_root
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


# sets up the necessary environment variables required for golang usage
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
    
      
