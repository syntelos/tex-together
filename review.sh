#!/bin/bash

2>/dev/null rm /tmp/review.* 

log=/tmp/review.$$

r_del=false

function usage {
    cat<<EOF>&2


Synopsis

  $0

Description

  Display files listed by './flist.sh \$*' using 'less'.


Synopsis

  $0 [-d]

Description

  After each file display (less quit) ask for input to log to file
  '/tmp/review'.


Synopsis

  $0 [-?|-h|--help]

Description

  This message.


EOF
}
#
if [ -n "${1}" ]
then
    if [ '-d' = "${1}" ]
    then
	r_del=true
	shift

    elif [ '-?' = "${1}" ]||[ '-h' = "${1}" ]||[ '--help' = "${1}" ]
    then
	usage
	exit 1
    fi
fi

#
if flist=$(./flist.sh $* ) && [ -n "${flist}" ]
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
