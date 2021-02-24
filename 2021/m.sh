#!/bin/bash

#
function git {
  echo git $* 
}

#
if [ -f m.db ]&& rm -f /tmp/batch
then
    idx=0
    while true
    do
        rm -f /tmp/batch
        cnt=0
        for mre in $(egrep -e "^${idx}:" m.db)
        do
            msg=$(echo ${mre} | awk -F: '{print $2}' | sed 's/%/ /g')
            src=$(echo ${mre} | awk -F: '{print $3}')

            # (batch interior)
            #
            tgt=$(../target.sh "${src}")

            echo ${src} >> /tmp/batch

            # (batch op)
            #
            if git mv -f "${src}" "${tgt}"
            then
                git status --porcelain "${tgt}"
            fi

            cnt=$(( ${cnt} + 1 ))
        done

        # (batch exterior)
        #
        if git commit -m "${msg}" $(cat /tmp/batch)
        then
            echo "# [${idx}] ${msg}"
        fi

        #
        if [ 0 -lt ${cnt} ]
        then
            idx=$(( ${idx} + 1 ))
        else
            break
        fi
    done
    exit 0
else
  cat<<EOF>&2
$0 error: missing resource 'm.db', or failed to vacate '/tmp/batch'.
EOF
  exit 1
fi
