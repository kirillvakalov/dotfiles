#!/bin/sh

# based on https://github.com/gokcehan/lf/wiki/Previews#with-sixel
case "$(file -Lb --mime-type -- "$1")" in
    image/*)
        exit 0
        ;;
    *)
        cat "$1"
        ;;
esac
