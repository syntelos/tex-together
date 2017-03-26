#!/bin/bash

file_txt=$(./file.sh $* txt | egrep '\.txt$')

if [ -n "${file_txt}" ]&&[ -f "${file_txt}" ]
then
    emacs ${file_txt} &

    exit 0
else
    cat<<EOF>&2
$0: file 'txt' not found.
EOF
    exit 1
fi
