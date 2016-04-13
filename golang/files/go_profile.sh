#!/usr/bin/env bash
{% from "golang/map.jinja" import config with context -%}
# WARNING!!   This file is managed by Salt
# All edits will be lost on the next highstate
export GOROOT={{ config.go_root }}
export GOPATH={{ config.go_path }}
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
