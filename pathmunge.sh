# SPDX-License-Identifier: MIT
# Copyright (c) Jorengarenar <dev@joren.ga>

pathmunge() {
    append=0
    sep=":"
    help=0

    while getopts "as:h" option; do
        case $option in
            a) append=1      ;;
            s) sep="$OPTARG" ;;
            h)
                help=1
                echo
                echo "Usage: "
                echo " pathmunge [OPTION]... [VARIABLE] [<VALUE>]"
                echo
                echo "Options:"
                echo " -a  append instead of prepend"
                echo " -s  use different separator than default ':'"
                echo " -h  display this help and exit"
                echo
                echo "Examples:"
                echo "  pathmunge ./bin               # prepends PATH with './bin'"
                echo "  pathmunge -a foo              # appends 'foo' to PATH"
                echo "  pathmunge CPATH ~/.local/lib  # prepends CPATH with '~/.local/lib'"
                echo "  pathmunge -s'|' FOO aa        # FOO = 'bb|cc' --> FOO = 'aa|bb|cc'"
                echo
                ;;
        esac
    done

    shift $(($OPTIND - 1))
    unset option OPTARG OPTIND

    if [ "$help" = "0" ]; then
        unset help append sep
        return
    fi

    if [ -z "$2" ]; then
        var='PATH'
        new="$1"
    else
        var="$1"
        new="$2"
    fi

    eval val="\$$var"

    if ! echo "$val" | grep -Eq '(^|'"$sep)$new("'$|'"$sep)" ; then
        if [ -z "$val" ]; then
            export "$var"="$new"
        elif [ "$append" = "0" ]; then
            export "$var"="$new$sep$val"
        else
            export "$var"="$val$sep$new"
        fi
    fi

    unset append sep help var new val
}
