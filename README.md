`pathmunge()`
=============

[![CodeFactor](https://www.codefactor.io/repository/github/jorengarenar/pathmunge.sh/badge)](https://www.codefactor.io/repository/github/jorengarenar/pathmunge.sh)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ec0f3530ef6b4c2f8e7d1b03faed5b0a)](https://app.codacy.com/gh/Jorengarenar/pathmunge.sh/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![GitHub License](https://img.shields.io/github/license/Jorengarenar/pathmunge.sh)](https://github.com/Jorengarenar/pathmunge.sh/blob/master/LICENSE)

`pathmunge()` is a shell function for adding directories to `PATH`
when the specified directory isn't already there.

This particular implementation allows for adding not only to `PATH`,
but to **any variable** containing separator-divided list of strings.

## Installation

Clone the repository and source the [`pathmunge.sh`](https://github.com/Jorengarenar/pathmunge.sh/blob/master/pathmunge.sh) file
```sh
git clone https://github.com/Jorengarenar/pathmunge.sh.git "$HOME/.local/lib/shell"
echo '. "$HOME/.local/lib/shell/pathmunge.sh/pathmunge.sh"' >> .profile
```

## Usage

```sh
usage: pathmunge [OPTION]... [VARIABLE] [<VALUE>]
   or: pathmunge [<VALUE>] before
   or: pathmunge [<VALUE>] after


options:
  -p  prepend to variable (default action)
  -a  append instead of prepend
  -s  use different separator than default ':'
  -h  display this help and exit

examples:
  $ pathmunge ./bin               # prepends PATH with './bin'
  $ pathmunge ./.local/bin after  # appends PATH with './.local/bin'
  $ pathmunge -a foo              # appends 'foo' to PATH
  $ pathmunge CPATH ~/.local/lib  # prepends CPATH with '~/.local/lib'
  $ pathmunge -s'|' FOO aa        # turns FOO='bb|cc' into FOO='aa|bb|cc'
  $ pathmunge -p BAR after        # prepends 'after' to BAR
```

### Examples

```sh
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin
$ pathmunge ~/.local/bin
$ echo $PATH
/home/user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
```

```sh
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin
$ pathmunge ~/.local/bin before
$ echo $PATH
/home/user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
```

```sh
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin
$ pathmunge ~/.local/bin after
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin:/home/user/.local/bin
```

```sh
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin
$ pathmunge /usr/bin
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin
```

```sh
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin
$ pathmunge -a ~/.local/bin
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin:/home/user/.local/bin
```

```sh
$ echo $CPATH

$ pathmunge CPATH ~/.local/lib
$ echo $CPATH
/home/user/.local/lib
$ pathmunge CPATH ./tests
$ echo $CPATH
/home/user/.local/lib:./tests
```

```sh
$ echo $FOO
bbb|ccc|ddd
$ pathmunge -s'|' FOO aaa
$ echo $FOO
aaa|bbb|ccc|ddd
```

```sh
$ echo $FOO
aaa|bbb|ccc
$ pathmunge -a -s'|' FOO ddd
$ echo $FOO
aaa|bbb|ccc|ddd
```

```sh
$ echo $after
1:2
$ pathmunge -p after x
$ echo $after
x:1:2
```

```sh
$ echo $after
1:2
$ pathmunge -a after 3
$ echo $after
1:2:3
```
