# SPDX-License-Identifier: MIT
# Copyright (c) Jorengarenar <dev@joren.ga>

pathmunge() {
    A=0  # append flag
    E=0  # use `eval` flag
    H=0  # show only help flag
    S=":" # separator

    while getopts "aes:h" option; do
        case $option in
            a) A=1 ;;
            e) E=1 ;;
            s) S="$OPTARG" ;;
            h)
                H=1
                echo
                echo "Usage: "
                echo " pathmunge [OPTION]... [VARIABLE] [<VALUE>]"
                echo
                echo "Options:"
                echo " -a  append instead of prepend"
                echo " -s  use different separator than default ':'"
                echo " -e  don't export (uses 'eval' instead)"
                echo " -h  display this help and exit"
                echo
                echo "Examples:"
                echo "  pathmunge ./bin               # prepends PATH with './bin'"
                echo "  pathmunge -a foo              # appends 'foo' to PATH"
                echo "  pathmunge CPATH ~/.local/lib  # prepends CPATH with '~/.local/lib'"
                echo "  pathmunge -s'|' FOO aa        # FOO = 'bb|cc' --> FOO = 'aa|bb|cc'"
                echo
                ;;
            ?) return ;;
        esac
    done

    shift $((OPTIND - 1))
    unset option OPTARG OPTIND

    if [ "$H" = "0" ]; then
        unset H A S
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

    case "$S$val$S" in
        *"$S$new$S"*) ;;
        "$S$S") updated="$new" ;;
        *) [ "$A" = "0" ] && updated="$new$S$val" || updated="$val$S$new" ;;
    esac

    if [ -n "$updated" ]; then
        if [ "$E" = "0" ]; then
            export "$var"="$updated"
        else
            eval "$var='$updated'"
        fi
    fi

    unset A S H var new val updated
}
