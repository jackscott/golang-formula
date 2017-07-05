#!/usr/bin/env bash
{% from "golang/map.jinja" import golang with context -%}
# WARNING!! This file is managed by Salt at <{{ source }}>
# All edits will be lost on the next highstate
export GOROOT={{ golang.go_root }}
export GOPATH={{ golang.go_path }}
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
