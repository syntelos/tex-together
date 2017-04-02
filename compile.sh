#!/bin/bash

prefix=together

function camel {

    b=$(echo "${1}" | sed 's/.//')

    a=$(echo "${1}" | sed "s%${b}%%" | tr '[a-z]' '[A-Z]')

    echo "${a}${b}"

    return 0
}
function digit {
    case "${1}" in

	*txt)
	    echo ${1} | sed "s^${prefix}-^^; s^\.txt^^; s^-[0-9]*^^;"
	    ;;

	*tex)
	    echo ${1} | sed "s^${prefix}-^^; s^\.tex^^; s^-[0-9]*^^;"
	    ;;
	*)
	    return 1
	    ;;
    esac
}

#
#
#
if flist=$(2>/dev/null ./flist.sh $* ) && [ -n "${flist}" ]
then

    if digits=$(digit ${flist} ) &&[ -n "${digits}" ]
    then
	if day=$(./log.sh ${digits} ) && [ -n "${day}" ]
	then
	    day=$(camel "${day}" )

	    ftgt=${prefix}-${digits}.tex

	    date=$(echo ${digits} | sed 's%^[0-9][0-9][0-9][0-9]%&/%; s%[0-9][0-9]$%/&%;')

	    cat<<EOF>${ftgt}
\input book

\centerline{\bf Together}
\centerline{\it ${day}, ${date}}


EOF

	    for srcf in ${flist} 
	    do
		case "${srcf}" in

		    *-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].[a-z][a-z][a-z])
			#
			# (reprocessing {ftgt})
			#
			;;

		    *)
			echo >>${ftgt}
			echo "\vfill">>${ftgt}
			echo "\break">>${ftgt}
			echo >>${ftgt}

			case "${srcf}" in
			    *.txt)
				cat ${srcf} >> ${ftgt}
				;;
			    *.tex)
				egrep -v '^\\(input|bye)' ${srcf} >> ${ftgt}
				;;
			    *)
				1>&2 echo "$0 error processing flist fext in '${srcf}'."
				exit 1
				;;
			esac
			;;
		esac
			
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
$0 error processing today's '${prefix}' files.
EOF
	exit 1
    fi
else
    cat<<EOF>&2
$0 error listing today's '${prefix}' files.
EOF
    exit 1
fi
