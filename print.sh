#!/bin/bash

prefix=together

#
#
function compile {

    name=$(basename ${src} .tex)

    tgt_png=${name}-%0d.png
    tgt_pdf=${name}.pdf
    tgt_ps=${name}.ps
    tgt_dvi=${name}.dvi

    #
    if [ -n "$(egrep '^\\input' ${src} )" ]
    then

	compiler='tex'

    elif [ -n "$(egrep '^\\documentclass' ${src} )" ]
    then

	compiler='latex'

    else
	cat<<EOF>&2
$0 error determining compiler for '${src}'.
EOF
	return 1
    fi

    #
    #
    echo ${compiler} ${src}

    #
    if ${compiler} ${src}
    then
	git add ${tgt_dvi}

	if dvips ${tgt_dvi}
	then
	    git add ${tgt_ps}

	    if ps2pdf ${tgt_ps} 
	    then
		git add ${tgt_pdf}
	    fi
	fi

	return 0
    else
	return 1
    fi
}

#
#
if src=$(./file.sh $* | sed 's^-[0-9*]*\.txt^.tex^') && [ -f "${src}" ]
then

    #
    if compile
    then

	echo "U ${name}"
	exit 0
    else

	echo "X ${name}"
	exit 1
    fi

else
    cat<<EOF>&2
$0 error file not found.
EOF
    exit 1
fi
