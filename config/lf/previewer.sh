#!/bin/sh

# based on https://github.com/gokcehan/lf/wiki/Previews#with-sixel
case "$(file -Lb --mime-type -- "$1")" in
    image/*)
        exit 0
        ;;
    *)
        bat --paging=never --color=always --style=numbers "$1"
        ;;
esac
