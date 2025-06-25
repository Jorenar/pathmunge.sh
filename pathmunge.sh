# SPDX-License-Identifier: MIT
# Copyright 2023-2025 Jorenar
# shellcheck shell=sh

_pathmunge_usage () {
    cat << EOF
usage: pathmunge [OPTION]... [--] [VARIABLE] [<VALUE>]
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
  $ pathmunge -s '|' FOO aa       # turns FOO='bb|cc' into FOO='aa|bb|cc'
  $ pathmunge -p BAR after        # prepends 'after' to BAR
EOF
}

pathmunge () {
    # compatibility with usual implementations (e.g. RedHat's)
    [ $# -eq 2 ] && case "$2" in
        before) set -- "$1" ;;
        after) set -- '-a' "$1" ;;
    esac

    _pathmunge_pre=1
    _pathmunge_sep=":"
    trap 'unset _pathmunge_pre _pathmunge_sep' EXIT

    while [ $# -gt 0 ]; do
        case "$1" in
            -h) _pathmunge_usage; return ;;
            -p) _pathmunge_pre=1 ;;
            -a) _pathmunge_pre=0 ;;
            -s) _pathmunge_sep="$2" ;;
            --) shift; break ;;
            -?*) >&2 echo "pathmunge: error: unknown option '$1"; return 1 ;;
            *) break ;;
        esac
        shift
    done

    if [ $# -eq 1 ]; then
        set -- 'PATH' "$1"
    elif [ -z "$1" ]; then
        return 0
    fi

    eval 'set -- "$1" "$'"$1"'" "$2" "$_pathmunge_sep"'
    # Result:
    #  $1 = var name
    #  $2 = var value
    #  $3 = new entry
    #  $4 = separator

    if [ -z "$2" ]; then
        eval "$1"'="$3"'
        return 0
    fi

    case "$4${2}$4" in
        *"$4${3}$4"*) return 0 ;;
    esac

    if [ "$_pathmunge_pre" -gt 0 ]; then
        eval "$1"'="$3$4$2"'
    else
        eval "$1"'="$2$4$3"'
    fi
}
