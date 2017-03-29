#!/bin/bash

overwrite=false

src_pr=journal
src_fx=tex

tgt_pr=together
tgt_fx=txt


function usage {
    cat<<EOF>&2

Synopsis

 $0 [-s src-name] [-o] 

Description

 Import today's '*.${src_fx}' from '${src_pr}'.

 Optionally redefine source from '${src_pr}' 
 to 'src-name'.

 Optionally overwrite target from source.

EOF
}

while [ -n "${1}" ]
do
    case "${1}" in

	-o)
	    overwrite=true
	    shift
	    ;;

	-s)
	    shift
	    if [ -n "${1}" ]&&[ -d ../"${1}" ]
	    then
		src_pr="${1}"
		shift
	    else
		cat<<EOF>&2
$0 error in argument source '${1}' is not a directory '../${1}'.
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

src_re="../${src_pr}/${src_pr}-$(yyyymmdd)-*.${src_fx}"

if src_flist=$(2>/dev/null ls ${src_re} | sort -V) && [ -n "${src_flist}" ]
then

    for src in ${src_flist}
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
    exit 0
else
    cat<<EOF>&2
$0 error file '${src_re}' not found.
EOF

    exit 1
fi
