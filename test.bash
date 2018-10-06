#!/bin/bash
#
# test for tt.bash
# run command
#   bash test.bash

function _ttr-filepath-test() {
    local actual
    local utime=1538320268

    actual=$(_ttr-filepath "$utime" "/path/to/dir")
    assert "$actual" = "/path/to/dir/20181001.log"
}

function _ttr-get-log-value-test() {
    local actual
    local ltsv="key1:value1\\tkey2:value2"

    actual=$(echo -e $ltsv | _ttr-get-log-value "key1")
    assert "$actual" = "value1"

    actual=$(echo -e $ltsv | _ttr-get-log-value "key2")
    assert "$actual" = "value2"
}

function _ttr-create-log-test() {
    local actual
    local expect
    local utime=1538320268

    actual=$(_ttr-create-log $utime start "read mail")
    expect=$(echo -e "time:20181001T001108+0900\\taction:start\\ttask:read mail\\tutime:1538320268")
    assert "$actual" = "$expect"

    actual=$(_ttr-create-log $utime start)
    expect=$(echo -e "time:20181001T001108+0900\\taction:start\\tutime:1538320268")
    assert "$actual" = "$expect"
}

function do-test() {
    source ./ttr.bash

    _ttr-filepath-test
    _ttr-get-log-value-test
    _ttr-create-log-test
}

function main() {
    test_dir="./test_dir"
    mkdir -p $test_dir

    curl -sS https://raw.githubusercontent.com/yosugi/assert.bash/v0.3.0/assert.bash > $test_dir/assert.bash

    # shellcheck source=./test_dir/assert.bash
    # shellcheck disable=SC1091
    source $test_dir/assert.bash

    do-test

    rm -rf $test_dir
}
main
