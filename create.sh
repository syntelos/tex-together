#!/bin/bash

prefix=together
subtitle=''
yyyymmdd=$(yyyymmdd)
index=1

function usage {
    cat<<EOF>&2
Synopsis

  $0 

Description

  Create new file "{prefix}-{yyyymmdd}-{x}.txt", for x = {1,...,N}.


Synopsis

  $0 %p'prefix'

Description

  Create new file "{prefix}-{yyyymmdd}-{x}.txt".


Synopsis

  $0 %s'subtitle'

Description

  Create new file "{prefix}-{yyyymmdd}-{x}-{subtitle}.txt".


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
file=${prefix}-${yyyymmdd}-${index}.txt

while [ -f ${file} ]
do
    index=$(( ${index} + 1 ))
    file=${prefix}-${yyyymmdd}-${index}.txt
done

#
if [ -n "${subtitle}" ]
then
    file=${prefix}-${yyyymmdd}-${index}-${subtitle}.txt
fi

#
cat<<EOF>${file}


EOF

echo ${file}

git add ${file}

emacs ${file} &
