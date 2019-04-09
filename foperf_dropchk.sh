#!/bin/bash
target_addr=$1
start_fanout=$2
fanout_max=$3
intval_max=$4
cliaddr1=10.0.0.11
cliaddr2=10.0.0.12
cliaddr3=10.0.0.13
proc_count=3
timermax=1200
add_step=100

ps -ef | grep [f]operf | grep [c]lient | awk '{print $2}' | xargs kill -9 2>/dev/null 1>&2 || :
ssh $cliaddr2 "ps -ef | grep [f]operf | grep [c]lient | awk '{print \$2}' | xargs kill -9 "  2>/dev/null 1>&2 || :
ssh $cliaddr3 "ps -ef | grep [f]operf | grep [c]lient | awk '{print \$2}' | xargs kill -9 "  2>/dev/null 1>&2 || :

# create header
OUTPUT="intval(ms) "
for i in `seq 100 100 ${intval_max}`
do
OUTPUT="${OUTPUT}"`printf "% 6d" $i`
done
OUTPUT="${OUTPUT}
---------------------------------------------------------------------------------
"
:> result_${cliaddr1}
#:> result_${cliaddr1}_2 
:> result_${cliaddr2}
#:> result_${cliaddr2}_2
:> result_${cliaddr3}
for i in `seq ${start_fanout} ${add_step} ${fanout_max}`
do
OUTPUT="${OUTPUT}Fan-out"`printf "% 4d " $i`
for j in `seq 100 100 ${intval_max}`
do
wake=$(($i / ${proc_count}))
res_val=0
timer=$timermax
echo interval:${j} fanout:${i}

index=0
/root/foperf/bin/client -startid ${index} -addr ${target_addr} -wake ${wake} -recvint ${j} -wakeint 200 -sport :7000 -dport :7001 -errorThreshold 6 -checkTimer 5000 -dropMode 1 1>> result_${cliaddr1} 2>&1 &
index=$(( $index + $wake ))
ssh $cliaddr2 "/root/foperf/bin/client -startid ${index} -addr ${target_addr} -wake ${wake} -recvint ${j} -wakeint 200 -sport :7000 -dport :7001 -errorThreshold 6 -checkTimer 5000 -dropMode 1 " 1>> result_${cliaddr2} 2>&1 &
index=$(( $index + $wake ))
ssh $cliaddr3 "/root/foperf/bin/client -startid ${index} -addr ${target_addr} -wake ${wake} -recvint ${j} -wakeint 200 -sport :7000 -dport :7001 -errorThreshold 6 -checkTimer 5000 -dropMode 1 " 1>> result_${cliaddr3} 2>&1 &

sleep 3

while true
do
#jobs_result=`ps -ef | grep [c]lient | grep [f]operf`
jobs_result=`jobs`
jobs_count=`echo "${jobs_result}" | grep Running | wc -l`
if [ ${jobs_count} -lt ${proc_count} ];then
res_val=1
echo -n ${jobs_count},
echo failed
break
fi
timer=$(($timer - 1))
sleep 1
echo -n ${jobs_count},
if [ "x${timer}" = "x0" ];then
echo passed
break
fi
done

sleep 3
kill %1 || :
sleep 3
kill %2 || :
sleep 3
kill %3 || :
sleep 3
ps -ef | grep [f]operf | grep [c]lient | awk '{print $2}' | xargs kill -9 2>/dev/null 1>&2 || :
ssh $cliaddr2 "ps -ef | grep [f]operf | grep [c]lient | awk '{print \$2}' | xargs kill -9 "  2>/dev/null 1>&2 || :
ssh $cliaddr3 "ps -ef | grep [f]operf | grep [c]lient | awk '{print \$2}' | xargs kill -9 "  2>/dev/null 1>&2 || :

OUTPUT="${OUTPUT}  `printf '%02d' $timer` "
#if [ "x$res_val" = "x0" ];then
#OUTPUT="${OUTPUT}  o "
#else
#OUTPUT="${OUTPUT}  x "
#fi

echo

done
OUTPUT="${OUTPUT}
"
sleep 15
done

echo ---------------------------------------------------------------------------------
echo "${OUTPUT}"
