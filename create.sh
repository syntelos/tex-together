#!/bin/bash

prefix=together
subtitle=''
yyyymmdd=$(yyyymmdd)


function usage {
    cat<<EOF>&2
Synopsis

  $0 

Description

  Create new file "{prefix}-{yyyymmdd}-{x}.tex", for x = {0,...,N}.


Synopsis

  $0 %p'prefix'

Description

  Create new file "{prefix}-{yyyymmdd}-{x}.tex".


Synopsis

  $0 %s'subtitle'

Description

  Create new file "{prefix}-{yyyymmdd}-{x}-{subtitle}.tex".


EOF
}

#
while [ -n "${1}" ]
do
    case "${1}" in

	%p*)
	    prefix=$(echo "${1}" | sed 's^%p^^')
	    ;;

	%s*)
	    subtitle=$(echo "${1}" | sed 's^%s^^')
	    ;;

	*)
	    usage
	    exit 1
	    ;;
    esac
    shift
done

#
# REQ-IX-ONE
#
#  Accept imports from manually generated indexing
#
index=1
file=${prefix}-${yyyymmdd}-${index}.tex

if [ -f ${file} ]
then
    
    while [ -f ${file} ]
    do
	index=$(( ${index} + 1 ))
	file=${prefix}-${yyyymmdd}-${index}.tex
    done
else
    #
    # REQ-IX-ZERO
    #
    #  Produce machine generated indexing
    #
    index=0
    file=${prefix}-${yyyymmdd}-${index}.tex

    while [ -f ${file} ]
    do
	index=$(( ${index} + 1 ))
	file=${prefix}-${yyyymmdd}-${index}.tex
    done
fi

#
if [ -n "${subtitle}" ]
then
    file=${prefix}-${yyyymmdd}-${index}-${subtitle}.tex
fi

#
cat<<EOF>${file}
\input preamble



\bye
EOF

echo ${file}

git add ${file}

emacs ${file} &
