#!/bin/bash

wd=$(dirname $0)

#
# documentation
#
function usage {
    cat<<EOF>&2
Synopsis

  $0 [%component] 

Description

  Create new file "{components}.tex".

EOF
}
for arg in $*
do
    case ${arg} in
        -h|-?)
        usage
        exit 1
        ;;
    esac
done
#
#
#
if file=$(${wd}/next.sh $*) &&[ -n "${file}" ]&&[ ! -f "${file}" ]
then
    cat<<EOF>${file}
\input preamble



\bye
EOF

    echo ${file}

    git add ${file}

    emacs ${file} &
else
    usage
    exit 1
fi
