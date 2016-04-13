#!/usr/bin/env bats

@test "go binary is in our \$PATH" {
  command -v go
}

@test "go version is 1.6" {
  run go version
  [[ ${lines[0]} =~ "1.6" ]]
}

@test "assert \$GOROOT is correct" {
  run bash -c "go env | sed '7q;d' | grep 'GOROOT=\"/var/lib/golang\"'"
  [ ${status} = 1 ]
}

@test "verify debugging output is relevant and archive_hash is a 'known known'" {
  run bash -c "grep archive_hash /tmp/golang-formula.log"
  [ ${status} = 0 ]
  [[ ${lines[0]} =~ "5470eac05d273c74ff8bac7bef5bad0b5abbd1c4052efbdbc8db45332e836b0b" ]]
}
