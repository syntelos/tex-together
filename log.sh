#!/bin/bash

function flog {

    if log=$(2>/dev/null git log ${file} | tail -n 1 | awk '{print $1}') && [ -n "${log}" ]
    then
	echo ${log}

	return 0
    else
	cat<<EOF>&2
$0 error retrieving log for file '${file}'.
EOF
	return 1
    fi
}

if [ -n "${1}" ]&&[ -f "${1}" ]
then
    file="${1}"

    if flog "${file}"
    then
	exit 0
    else
	exit 1
    fi

elif file=$(2>/dev/null ./file.sh $* ) &&[ -n "${file}" ]&&[ -f "${file}" ]
then

    if flog "${file}"
    then
	exit 0
    else
	exit 1
    fi
else
    cat<<EOF>&2
$0 error in file lookup.
EOF
    exit 1
fi
