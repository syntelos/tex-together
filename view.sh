#!/bin/bash

file_dvi=$(./file.sh $* dvi | egrep '\.dvi$')

file_txt=$(./file.sh $* txt | egrep '\.txt$')

if [ -f "${file_dvi}" ]&&[ -f "${file_txt}" ]&&[ "${file_dvi}" -nt "${file_txt}" ]
then
    xdvi ${file_dvi} &

    exit 0
elif [ -f "${file_txt}" ]
then
    cat -n ${file_txt}  

    exit 0

elif [ -f "${file_dvi}" ]
then
    xdvi ${file_dvi}  

    exit 0

else
    cat<<EOF>&2
$0: file "${file_txt}" not found.
EOF
    exit 1
fi
