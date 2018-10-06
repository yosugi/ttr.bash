#!/bin/bash

# CLI task time recorder for bash.
#
# Usage:
#
# ttr action [task name]
# ttr [options]
#
# Example:
# 
# $ ttr start someTask
# time:20181006T111108+0900       action:start    task:someTask      utime:1538791868
# $ ttr end
# time:20181006T111131+0900       action:end      utime:1538791891
# $ ttr -c
# time:20181006T111108+0900       action:start    task:someTask      utime:1538791868
# time:20181006T111131+0900       action:end      utime:1538791891
# $ ttr -t 1 | ttr -g utime
# 1538791891
#
# Author : yosugi
# License: MIT

if [ -z "$TTR_DIR" ]; then
    TTR_DIR=$HOME/.local/share/ttr
fi
export TTR_DIR
[[ -d "$TTR_DIR" ]] || mkdir -p "$TTR_DIR"

TTR_EDITOR=${TTR_EDITOR:-$EDITOR}
TTR_EDITOR=${TTR_EDITOR:-vi}
export TTR_EDITOR

function ttr() {
    _ttr-io "$@"
}

function _ttr-io() {
    case $1 in
        ('--file'|'-f')
            _ttr-filepath-io;;
        ('--list'|'-l')
            _ttr-filelist-io;;
        ('--cat'|'-c')
            _ttr-cat-io;;
        ('--tail'|'-t')
            _ttr-tail-io "$2";;
        ('--edit'|'-e')
            _ttr-edit-io;;
        ('--get'|'-g')
            _ttr-get-log-value "$2";;
        ('--help'|'-h')
            _ttr-help;;
        ("--version"|"-v")
            _ttr-version;;
        (*)
            if [ $# -eq 0 ]; then
                echo -e "invalid argument\\n"
                _ttr-help
            else
                _ttr-create-log "$(date '+%s')" "$1" "$2" | _ttr-append-log-io
                _ttr-tail-io 1
            fi;;
    esac
}

function _ttr-filepath-io() {
    _ttr-filepath "$(date '+%s')" "$TTR_DIR"
}

function _ttr-filepath() {
    local utime=$1
    local dir=$2

    local today
    today=$(echo "$utime" | awk '{print strftime("%Y%m%d", $1)}')

    echo "${dir}/${today}.log"
}

function _ttr-filelist-io() {
    ls -1 "${TTR_DIR}"/*
}

function _ttr-get-log-value() {
    local key=$1
    tr "\\t" "\\n" | grep "$key" | cut -f 2 -d":"
}

function _ttr-append-log-io() {
    cat - >> "$(_ttr-filepath-io)"
}

function _ttr-create-log() {
    local utime=$1
    local task_action=$2
    local time

    # convert ISO 8601 basic format
    time=$(echo "$utime" | awk '{print strftime("%Y%m%dT%H%M%S%z", $1)}')

    if [ -z "$3" ]; then
        echo -e "time:${time}\\taction:${task_action}\\tutime:${utime}"
    else
        local task_name=$3
        echo -e "time:${time}\\taction:${task_action}\\ttask:${task_name}\\tutime:${utime}"
    fi
}

function _ttr-cat-io() {
    cat "$(_ttr-filepath-io)"
}

function _ttr-tail-io() {
    if [ -z "$1" ]; then
        tail "$(_ttr-filepath-io)"
    else
        tail "-$1" "$(_ttr-filepath-io)"
    fi
}

function _ttr-edit-io() {
    $TTR_EDITOR "$(_ttr-filepath-io)"
}

function _ttr-version() {
    echo "v0.1.0"
}

function _ttr-help() {
    local ttr_version
    local ttr_filepath

    ttr_version=$(_ttr-version)
    ttr_filepath=$(_ttr-filepath-io)

cat <<EOT
ttr - A simple task time recorder

Usage:
    ttr action [task name]
    ttr [options]

Options:
    -f, --file     show current file path
    -l, --list     show file list
    -c, --cat      cat file contents
    -t, --tail     tail file contents
    -g, --get      get ltsv value by given key
    -h, --help     show help message
    -v, --version  print the version

File:
    $ttr_filepath

Version:
    $ttr_version
EOT
}
