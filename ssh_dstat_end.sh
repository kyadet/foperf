#!/bin/bash -e
remote_addr=$1
recv_dir=$2

logdir=./logs
logfile=${logdir}/foperf_m_dstat_${remoteaddr}.log
rm=/bin/rm
dstat=/bin/dstat
dstat_opt="-Tlan"

scp $remote_addr:${logfile} ${recv_dir}
ssh $remote_addr "${rm} -rf ${logfile} "

exit 0
