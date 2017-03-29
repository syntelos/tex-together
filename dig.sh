#!/bin/bash

if flist=$(./flist.sh $* ) && [ -n "${flist}" ]
then
  for fel in ${flist} 
  do
    echo ${fel} | sed 's%^[a-z]*-%%; s%\.[a-z][a-z][a-z]$%%;'
  done
  exit 0
else
  cat<<EOF>&2
$0 error file not found.
EOF
  exit 1
fi
