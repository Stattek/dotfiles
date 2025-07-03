#!/usr/bin/env bash

GATHER_DOTFILES_LIST="
~/.bashrc
~/.bash_aliases
~/.clang-format
~/.config/kitty/kitty.conf
/usr/local/bin/backup_folder
"

for file in $GATHER_DOTFILES_LIST; do
    OUTPUT_FILE="$file"

    # handle files that are home paths
    if [[ "${OUTPUT_FILE:0:1}" = "~" ]]; then
        OUTPUT_FILE=`echo "$OUTPUT_FILE" | sed "0,/\//{s/\~\///}"`
        # since files wrapped with quotes them can't find home
        file=`echo "$HOME/$OUTPUT_FILE"`
    fi

    # handle files that are absolute paths
    if [[ "${OUTPUT_FILE:0:1}" = "/" ]]; then
        OUTPUT_FILE=`echo "$OUTPUT_FILE" | sed "0,/\//{s/\///}"`
    fi

    # if it is in a subdirectory, we need to handle that
    OUTPUT_FILE_DIR=`echo "$OUTPUT_FILE" | rev | cut -d "/" -f2- | rev`

    # check that the output file is meant to be in a subdirectory
    echo "$OUTPUT_FILE" | grep "/" > /dev/null && mkdir -p "$OUTPUT_FILE_DIR"
    echo "Copying '$file' to '$OUTPUT_FILE'..."
    cp "$file" "$OUTPUT_FILE"
done

echo "### Gathering complete"
