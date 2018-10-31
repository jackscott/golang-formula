#!/usr/bin/env bats

@test "go binary is in our \$PATH" {
  command -v go
}


@test "go version is 1.8.3" {
  run go version
  [[ ${lines[0]} =~ "1.8.3" ]]

}

@test "assert \$GOROOT is correct" {
  run bash -c "go env | sed '7q;d' | grep 'GOROOT=\"/var/lib/golang\"'"
  [ ${status} = 1 ]
}

@test "verify debugging output is relevant and archive_hash is a 'known known'" {
  run bash -c "grep archive_hash /tmp/golang-formula.log"
  [ ${status} = 0 ]
  [[ ${lines[0]} =~ "5f5dea2447e7dcfdc50fa6b94c512e58bfba5673c039259fd843f68829d99fa6" ]]

}
