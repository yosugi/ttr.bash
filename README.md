# ttr

CLI task time recorder for bash.

## Features

* Record your task time start, end and etc...
* Time is written in daily plain text file
* To use LTSV format
* Simple LTSV parser
* Single file application

## Usage

```
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
```

## Examples

```
$ ttr start someTask
time:20181006T111108+0900       action:start    task:someTask      utime:1538791868
$ ttr end
time:20181006T111131+0900       action:end      utime:1538791891
$ ttr -c
time:20181006T111108+0900       action:start    task:someTask      utime:1538791868
time:20181006T111131+0900       action:end      utime:1538791891
$ ttr -t 1 | ttr -g utime
1538791891
```

## Installation

```
$ curl -sS https://raw.githubusercontent.com/yosugi/ttr.bash/master/ttr.bash > ~/.ttr.bash
$ echo '[ -f ~/.ttr.bash ] && source ~/.ttr.bash' >> ~/.bashrc
$ source ~/.ttr.bash
```

## Configuration

$TTR_DIR    specify log dir (default: $HOME/.local/share/ttr)
$TTR_EDITOR specify editor (default: vi)

## License

MIT License
