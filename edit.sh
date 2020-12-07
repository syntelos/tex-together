#!/bin/bash


file_png=$(./file.sh $* png | egrep '\.png$' )



if [ -n "${file_png}" ]&&[ -f "${file_png}" ]
then
    gimp ${file_png}  &

    exit 0
else
    cat<<EOF>&2
$0: file 'png' not found.
EOF
    exit 1
fi

