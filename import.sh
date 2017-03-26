#!/bin/bash

src_pr=journal
src_fx=tex

tgt_pr=together
tgt_fx=txt

src_re="../${src_pr}/${src_pr}-$(yyyymmdd)-*.${src_fx}"

if src_flist=$(2>/dev/null ls ${src_re} | sort -V) && [ -n "${src_flist}" ]
then

    for src in ${src_flist}
    do
	tgt=$(basename ${src} .${src_fx} | sed "s/${src_pr}/${tgt_pr}/").${tgt_fx}

	if [ -f "${tgt}" ]
	then
	    echo "X ${tgt}"
	else
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
