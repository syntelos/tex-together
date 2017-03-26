#!/bin/bash
#
prefix=together

function usage {
    cat<<EOF>&2
Synopsis

  $0 

Description

  Print current file for file name extension 'tex'.


Synopsis

  $0  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]

Description

  Absolute addressing reference, YYYYMMDD for 
  "ls ${prefix}-{ref}*.fext".


Synopsis

  $0  [a-z][a-z][a-z]

Description

  Output with file name extension '[a-z][a-z][a-z]'.


Synopsis

  $0  '*'

Description

  Output with file name extension '*'.


Synopsis

  $0 %[di][+-]N

Description

  Relative addressing reference in delta arithmetic over current file
  date (%d-1) or item (%i+1) for single digit N.


Synopsis

  $0 %p'prefix'

Description

  Relative addressing reference to file name prefix, i.e.,
  "prefix-YYYYMMDD-I.fext".


Synopsis

  $0 %s'subtitle'

Description

  Relative addressing reference including optional file name suffix
  subtitle, e.g., "${prefix}-YYYYMMDD-I-subtitle.fext".


EOF
    return 1
}

#
#
fext=''
del_date=0
del_item=0
subtitle=''
ref=''


#
#
while [ -n "${1}" ]
do
    case "${1}" in

	%d[+-][0-9])
	    exp="0 $(echo ${1} | sed 's/%d//; s/./& /;')"

	    del_date=$(( ${exp} ))

	    del_date="$(echo ${del_date} | sed 's/./& /; s/^ //; s/ $//; s/^[0-9]/+ &/;')"
	    ;;

	%i[+-][0-9])
	    exp="0 $(echo ${1} | sed 's/%i//; s/./& /;')"

	    del_item=$(( ${exp} ))

	    del_item="$(echo ${del_item} | sed 's/./& /; s/^ //; s/ $//; s/^[0-9]/+ &/;')"
	    ;;

	%p*)
	    prefix=$(echo "${1}" | sed 's^%p^^')
	    ;;

	%s*)
	    subtitle=$(echo "${1}" | sed 's^%s^^')
	    ;;

	[+-]*)
	    usage 
	    exit 1
	    ;;

	[a-z][a-z][a-z])
	    fext="${1}"
	    ;;

	\*)
	    fext="${1}"
	    ;;

	[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]*)

	    ref="${1}"
	    ;;

	*)
	    usage
	    exit 1
	    ;;
    esac
    shift
done

#
#  REQS
#
#    To date the requirements for this script have excluded the
#    "blind" or "nonexistent" or "create" case.  It is only
#    responsible for identifying files that exist at the time it runs.
#    This attribute of its requirements closes the difference between
#    referencing and generating, as represented by REQS-REF-QUERY and
#    REQS-REF-CANON.
#
#    Note the case of ( p-x-y.f | p-x.f ), beyond ( p-x-y.f ), the
#    selection of {p-x.f} over {p-x-y.f} is a subtlety left to 'sort
#    -V', 'tail -n 1', and the temporal work flow process.
#
#
#    REF-GENER
#
#     The output of a nonexistent file reference is the "generate" or
#     "generative" case, also known as the "blind" or "nonexistent" or
#     "create" case.  This case is found in the application of this
#     script to file existence testing found in the "./edit.sh" and
#     "./view.sh" script.  In this case the user-script needs to
#     filter-exclude the output for its own existence-expectation
#     requirement.
#
#
#    REF-QUERY
#
#      When the request/expectation is relatively concrete
#
#        * Last in sequence referenced by {X{,Y{,Z}}}
#
#          * ( RRRRRR-RRRRRRRR-R.RRR | {prefix}-YYYYMMDD-X.txt |
#                RRRRRR-RRRRRRRR.RRR | {prefix}-YYYYMMDD.txt )?
#
#
#    REF-CANON
#
#      When the request/expectation is relatively abstract
#
#        * Last in sequence known to S^{*}
#
#          * ( {prefix}-YYYYMMDD-X.RRR | {prefix}-YYYYMMDD-X.txt |
#                {prefix}-YYYYMMDD.RRR | {prefix}-YYYYMMDD.txt )?
#
#
if [ -n "${ref}" ]
then

    if [ -n "${fext}" ]&&[ ! '*' = "${fext}" ]
    then
	file=$(2>/dev/null ls ${prefix}-*.* | sort -V | egrep -e "${ref}" | egrep -ve '[0-9][0-9][0-9][0-9][0-9][0-9]-[1-9]-[a-zA-Z]' | egrep "\.${fext}\$" | tail -n 1 )
    else
	file=$(2>/dev/null ls ${prefix}-*.* | sort -V | egrep -e "${ref}" | egrep -ve '[0-9][0-9][0-9][0-9][0-9][0-9]-[1-9]-[a-zA-Z]' | tail -n 1 )
    fi

else

    if [ -n "${fext}" ]&&[ ! '*' = "${fext}" ]
    then
	file=$(2>/dev/null ls ${prefix}-*.* | sort -V | egrep -ve '[0-9][0-9][0-9][0-9][0-9][0-9]-[1-9]-[a-zA-Z]' | egrep "\.${fext}\$" | tail -n 1 )
    else
	file=$(2>/dev/null ls ${prefix}-*.* | sort -V | egrep -ve '[0-9][0-9][0-9][0-9][0-9][0-9]-[1-9]-[a-zA-Z]' | tail -n 1 )
    fi

fi

#
if [ -n "${file}" ]&&[ -f "${file}" ]
then

    digits=$(echo ${file} | sed "s%${prefix}-%%; s%\..*\$%%;" )

    #
    if [ "0" != "${del_date}" ] || [ "0" != "${del_item}" ]
    then
	base_date=$(echo "${digits}" | sed 's%-.$%%;')

	base_item=$(echo "${digits}" | sed "s%${base_date}%%; s%-%%;")

	if [ "0" != "${del_item}" ]
	then
	    base_item=$(( ${base_item} ${del_item} ))
	fi

	if [ "0" != "${del_date}" ]
	then
	    base_date=$(( ${base_date} ${del_date} ))
	fi

	base="${prefix}-${base_date}-${base_item}"
    else
	base="${prefix}-${digits}"
    fi

    #
    if [ -n "${subtitle}" ]
    then
	base="${base}-${subtitle}"
    fi

    #
    if [ '*' = "${fext}" ]||[ -f "${base}.${fext}" ]
    then
	file="${base}.${fext}"

    elif [ -f "${base}.txt" ]
    then
	file="${base}.txt"

    elif [ -f "${base}.tex" ]
    then
	file="${base}.tex"
    fi

    #
    if [ -n "${file}" ]&&[ -f "${file}" ]
    then
	echo "${file}"

	exit 0
    else
	cat<<EOF>&2
$0: file not found.
EOF
	exit 1
    fi
else

    cat<<EOF>&2
$0: file not found.
EOF
    exit 1
fi

