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
client=/root/foperf/bin/client

ssh $remote_addr "${client} -startid ${startid} -addr ${target_addr} -wake ${wake_count} -recvint ${recv_intval} -wakeint ${wake_intval} -sport :${sport} -dport :${dport} -errorThreshold ${error_threshold} -checkTimer ${check_timer} 1>> ${logfile} 2>&1 & "
