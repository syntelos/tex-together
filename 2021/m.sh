#!/bin/bash

if [ -f m.db ]
then


else
  cat<<EOF>&2
$0 error: missing resource 'm.db'.
EOF
  exit 1
fi
