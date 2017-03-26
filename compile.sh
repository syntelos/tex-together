#!/bin/bash

prefix=together

function camel {

    b=$(echo "${1}" | sed 's/.//')

    a=$(echo "${1}" | sed "s%${b}%%" | tr '[a-z]' '[A-Z]')

    echo "${a}${b}"

    return 0
}

if flist=$(2>/dev/null ./flist.sh $* ) && [ -n "${flist}" ]
then

    digits=$(echo ${flist} | sed "s^${prefix}-^^; s^\.txt.*^^; s^-[0-9]*^^;")
    
    if day=$(./log.sh ${digits} ) && [ -n "${day}" ]
    then
	day=$(camel "${day}" )

	ftgt=${prefix}-${digits}.tex

	date=$(echo ${digits} | sed 's%^[0-9][0-9][0-9][0-9]%&/%; s%[0-9][0-9]$%/&%;')

	cat<<EOF>${ftgt}
\input book

\centerline{\bf Distance}
\centerline{\it ${day}, ${date}}


EOF

	for srcf in ${flist} 
	do
	    echo >>${ftgt}
	    echo "\vfill">>${ftgt}
	    echo "\break">>${ftgt}
	    echo >>${ftgt}
	    cat ${srcf} >> ${ftgt}
	done

	cat<<EOF>>${ftgt}

\vfill
\bye
EOF

	echo "A ${ftgt}"
	git add ${ftgt}

    else
	cat<<EOF>&2
$0 error retrieving log message for file listing '${fhead}'.
EOF
    fi
else
    cat<<EOF>&2
$0 error listing today's 'together' files.
EOF
    exit 1
fi

