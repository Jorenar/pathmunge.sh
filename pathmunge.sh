# SPDX-License-Identifier:  MIT
# Copyright 2023 Jorengarenar

# shellcheck shell=sh

pathmunge () {
    case " $@ " in
        " -h ")
            cat << EOF
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
EOF
        return 0
        ;;
    esac

    if [ $# = 2 ]; then
        if [ -z "$1" ] || [ -z "$2" ]; then
            return 0
        fi

        # compatibility with usual (e.g. Red Hat's) implementations
        if [ "$2" = "before" ] || [ "$2" = "after" ]; then
            case ":${PATH}:" in
                *:"$1":*) ;;
                *) [ "$2" = "before" ] && PATH="$1:$PATH" || PATH="$PATH:$1" ;;
            esac
            return 0
        fi
    fi

    # shellcheck disable=SC2046
    eval "$(
        while getopts "pas:" o; do :; done
        shift $((OPTIND - 1))
        test -z "$2" && echo 'PATH' || echo "$1"
    )"=\"$(
        A=0   # append flag
        S=":" # separator

        while getopts "pas:" o; do
            case "$o" in
                p) A=0 ;;
                a) A=1 ;;
                s) S="$OPTARG" ;;
                ?)
                    >&2 echo "pathmunge: error: unknown option '$o"
                    return
                    ;;
            esac
        done
        shift $((OPTIND - 1))

        if [ -z "$2" ]; then
            var='PATH'
            new="$1"
        else
            var="$1"
            new="$2"
        fi

        old=
        eval old="\$$var"

        case "${S}${old}${S}" in
            *"${S}${new}${S}"*)
                updated="$old"
                ;;
            "${S}${S}")
                updated="$new"
                ;;
            *)
               if [ "$A" -eq 0 ]; then
                   updated="${new}${S}${old}"
               else
                   updated="${old}${S}${new}"
               fi
               ;;
        esac

        echo "$updated" | sed \
            -e 's+\\+\\\\\\+g' \
            -e 's/\$/\\$/g' \
            -e 's/"/\\"/g'
    )\"
}
