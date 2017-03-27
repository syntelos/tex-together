#!/bin/bash

prefix=together

yyyymmdd=$(yyyymmdd)
index=1
fext=''

function usage {
    cat<<EOF>&2
Synopsis

  $0 (txt|tex)

Description

  Create new file "{prefix}-{yyyymmdd}-{x}.fext", for x = {1,...,N}.

  The TXT file is for compilation a la DISTANCE, and the TEX file is
  for printing a la JOURNAL.

EOF
}
function file_exists {

    return 
}

#
if [ -n "${1}" ]
then
    case "${1}" in

	tex)
	    fext=tex
	    ;;
	txt)
	    fext=txt
	    ;;
	*)
	    usage
	    exit 1
	    ;;
    esac
else
    usage
    exit 1
fi

#
file=${prefix}-${yyyymmdd}-${index}

while [ -f "${file}".txt ]||[ -f "${file}".tex ]
do
    index=$(( ${index} + 1 ))

    file=${prefix}-${yyyymmdd}-${index}
done

file=${file}.${fext}

#
if [ 'txt' = "${fext}" ]
then
    cat<<EOF>${file}


EOF
elif [ 'tex' = "${fext}" ]
then
    cat<<EOF>${file}
\input preamble-png


\bye
EOF

else
    cat<<EOF>&2
$0 error internal FEXT '${fext}' unrecognized
EOF
    exit 1
fi

#
echo ${file}

git add ${file}

emacs ${file} &
