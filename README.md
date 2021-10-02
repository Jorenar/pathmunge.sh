`pathmunge()`
=============

`pathmunge()` is a shell function for adding directories to `PATH`
when the specified directory isn't already there.

This particular implementation allows for adding not only to `PATH`,
but to **any variable** with similar structure.

It uses `getopts` thus options are **incompatible** with typical
implementation (found e.g. on distributions from Red Hat familiy).

## Installation

Clone the repository and source the [`pathmunge.sh`](https://github.com/Jorengarenar/pathmunge.sh/blob/master/pathmunge.sh) file
```sh
git clone https://github.com/Jorengarenar/pathmunge.sh.git "$HOME/.local/lib/shell"
echo '. "$HOME/.local/lib/shell/pathmunge.sh/pathmunge.sh"' >> .profile
```

## Usage
```sh
pathmunge [OPTION]... [VARIABLE] [<VALUE>]
```

```
Options:
 -a  append instead of prepend
 -s  use different separator than default ':'
 -h  display this help and exit
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
