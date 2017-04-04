#!/bin/bash

overwrite=false

ref=$(yyyymmdd)

src_pr=journal
src_fx=tex

tgt_pr=distance
tgt_fx=txt


function usage {
    cat<<EOF>&2


Synopsis

 $0 [-o] 

Description

 Import today's '${src_fx}' from '${src_pr}' into '${tgt_pr}' with
 '${tgt_fx}'.

 Optionally overwrite (local directory) target from source.


Synopsis

 $0 -r YYYYMMDD

Description

 Import the referenced selection, '${src_pr}-RRRRRRRR-*.${src_fx}'
 into '${tgt_pr}' with '${tgt_fx}'.


Synopsis

 $0 [-sp prefix1] [-sx fext1] [-tp prefix2] [-tx fext2]

Description

 Optionally redefine source prefix from '${src_pr}' to 'prefix1', or
 target prefix from '${tgt_pr}' to 'prefix2' within the local
 directory.

 Optionally redefine source filename extension from '${src_fx}' to
 'fext1', or target filename extension from '${tgt_fx}' to 'fext2'.

 Optionally overwrite target from source.


Sources

 Note that the source prefix will be employed as an external sibling
 directory location, as well as a file naming prefix, when that
 directory (../{prefix}) exists.

EOF
}

while [ -n "${1}" ]
do
    case "${1}" in

	-o)
	    overwrite=true
	    shift
	    ;;

	-r)
	    shift
	    if [ -n "${1}" ]
	    then
		ref="${1}"
		shift
	    else
		cat<<EOF>&2
$0 error missing argument to '-r'.
EOF
		exit 1
	    fi
	    ;;

	-sp)
	    shift
	    if [ -n "${1}" ]
	    then
		src_pr="${1}"
		shift
	    else
		cat<<EOF>&2
$0 error missing argument to '-sp'.
EOF
		exit 1
	    fi
	    ;;

	-tp)
	    shift
	    if [ -n "${1}" ]
	    then
		tgt_pr="${1}"
		shift
	    else
		cat<<EOF>&2
$0 error missing argument to '-tp'.
EOF
		exit 1
	    fi
	    ;;

	-sx)
	    shift
	    if [ -n "${1}" ]&&[ -n "$(echo ${1} | egrep '^[a-z][a-z][a-z]$')" ]
	    then
		src_fx="${1}"
		shift
	    else
		cat<<EOF>&2
$0 error missing or unrecognized argument to -sx '${1}' (does not match rexp '[a-z][a-z][a-z]').
EOF
		exit 1
	    fi
	    ;;

	-tx)
	    shift
	    if [ -n "${1}" ]&&[ -n "$(echo ${1} | egrep '^[a-z][a-z][a-z]$')" ]
	    then
		tgt_fx="${1}"
		shift
	    else
		cat<<EOF>&2
$0 error missing or unrecognized argument to -tx '${1}' (does not match rexp '[a-z][a-z][a-z]').
EOF
		exit 1
	    fi
	    ;;

	*)
	    usage
	    exit 1
	    ;;
    esac
done

#
#
function imp {

    for src in $*
    do
	tgt=$(basename ${src} .${src_fx} | sed "s/${src_pr}/${tgt_pr}/").${tgt_fx}

	if [ -f "${tgt}" ]&&[ 'false' = "${overwrite}" ]
	then
	    echo "X ${tgt}"

	elif [ "txt" = "${src_fx}" ]&&[ "tex" = "${tgt_fx}" ]
	then
	    echo '\input preamble' > ${tgt}
	    echo >> ${tgt}
	    cat ${src} >> ${tgt}
	    echo >> ${tgt}
	    echo '\bye' >> ${tgt}

	    2>/dev/null git add ${tgt}

	    echo "U ${tgt}"

	elif [ "tex" = "${src_fx}" ]&&[ "txt" = "${tgt_fx}" ]
	then
	    egrep -v '^\\(input|bye)' ${src} > ${tgt}

	    2>/dev/null git add ${tgt}

	    echo "U ${tgt}"
	fi

    done
}

src_re="${src_pr}-${ref}-*.${src_fx}"

if [ -d "../${src_pr}" ]&& src_flist=$(2>/dev/null ls ../${src_pr}/${src_re} | sort -V) && [ -n "${src_flist}" ] 
then

    if imp ${src_flist}
    then
	exit 0
    else
	exit 1
    fi

elif src_flist=$(2>/dev/null ls ${src_re} | sort -V) && [ -n "${src_flist}" ] 
then

    if imp ${src_flist}
    then
	exit 0
    else
	exit 1
    fi
else
    cat<<EOF>&2
$0 error file '${src_re}' not found.
EOF

    exit 1
fi
