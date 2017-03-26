#!/bin/bash

fext=txt

function usage {
  cat<<EOF
Synopsis

  $0 -d [0-9]* 

Description

  Review a number of documents producing a temp file of query
  responses.  The argument is a date pattern, e.g. "201701" or 
  prefix.


Synopsis

  $0 [0-9]* 

Description

  Review a number of documents following a date pattern, e.g. "201701"
  or prefix.

EOF
  exit 1
}

2>/dev/null rm /tmp/review.* 

log=/tmp/review.$$

r_del=false

re=$(yyyymmdd)

#
while [ -n "${1}" ]
do
    case "${1}" in
	[0-9]*)
	    re="${1}"
	    ;;
	[a-z-]*)
	    re="${1}"
	    ;;
	-d)
	    r_del=true
	    ;;
	*)
	    usage
	    exit 1
	    ;;
    esac
    shift
done

#
if flist=$(2>/dev/null ls *${re}*.${fext} | sort -V ) && [ -n "${flist}" ]
then
 for src in ${flist}
 do
   less ${src}

   if ${r_del}
   then
       read -p "delete? [yN] " -n 1 r_del
       case "${r_del}" in
	   [yY])
	       echo "D ${src}" >> ${log}
	       echo # (read -n 1)
	       ;;
	   [nN])
	       echo "X ${src}" >> ${log}
	       echo # (read -n 1)
	       ;;
	   *)
	       echo "X ${src}" >> ${log}
	       ;;
       esac
   fi

 done
 exit 0
else
 cat<<EOF>&2
$0 error, empty list of files from 'ls *${re}*.${fext}'.
EOF
 exit 1
fi
