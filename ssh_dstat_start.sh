#!/bin/bash -e
remote_addr=$1

logdir=./logs
logfile=${logdir}/foperf_m_dstat_${remoteaddr}.log
rm=/bin/rm
dstat=/bin/dstat
dstat_opt="-Tlan"

ssh $remote_addr "${rm} -rf ${logfile} "
ssh $remote_addr "nohup ${dstat} ${dstat_opt} 1> ${logfile} 2>&1 & "

exit 0
