#!/bin/bash -e
remote_addr=$1

pkill=/bin/pkill
dstat=/bin/dstat
dstat_opt="-Tlan"

ssh $remote_addr "${pkill} ${dstat} "

exit 0
