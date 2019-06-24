#!/bin/bash
remote_addr=$1
target_addr=$2
startid=$3
wake_count=$4
recv_intval=$5
wake_intval=$6
sport=$7
dport=$8
error_threshold=$9
check_timer=${10}

logdir=./logs
logfile=${logdir}/foperf_m_console_${remoteaddr}.log

scp $remote_addr:${logfile} ${recv_dir}
ssh $remote_addr "${rm} -rf ${logfile} "

exit 0
