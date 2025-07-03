#!/usr/bin/env bash

GATHER_DOTFILES_LIST="
~/.bashrc
~/.bash_aliases
~/.clang-format
~/.config/kitty/kitty.conf
/usr/local/bin/backup_folder
"

echo "DOTFILES=$GATHER_DOTFILES_LIST"

for file in $GATHER_DOTFILES_LIST; do
    echo "file=$file"
    OUTPUT_FILE="$file"

    # handle files that are home paths
    if [[ "${OUTPUT_FILE:0:1}" = "~" ]]; then
        OUTPUT_FILE=`echo "$OUTPUT_FILE" | sed "0,/\//{s/\~\///}"`
        # since files wrapped with quotes them can't find home
        file=`echo "$OUTPUT_FILE"`
        file=`echo "$HOME/$file"`
    fi

    # handle files that are absolute paths
    if [[ "${OUTPUT_FILE:0:1}" = "/" ]]; then
        OUTPUT_FILE=`echo "$OUTPUT_FILE" | sed "0,/\//{s/\///}"`
    fi

    # if it is in a subdirectory, we need to handle that
    OUTPUT_FILE_DIR=`echo "$OUTPUT_FILE" | rev | cut -d "/" -f2- | rev`

    # check that the output file is meant to be in a subdirectory
    echo "$OUTPUT_FILE" | grep "/" > /dev/null && mkdir -p "$OUTPUT_FILE_DIR"
    echo "OUTPUT_FILE_DIR= $OUTPUT_FILE_DIR"
    echo "OUTPUT_FILE= $OUTPUT_FILE"
    echo "cp $file $OUTPUT_FILE"
    ls "$file"
    cp "$file" "$OUTPUT_FILE"
    cp ~/.bashrc .bashrc
done

