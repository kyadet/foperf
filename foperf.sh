#!/bin/bash
target_addr=$1
fanout_max=$2
intval_max=$3

# create header
OUTPUT="intval(ms) "
for i in `seq 100 100 ${intval_max}`
do
OUTPUT="${OUTPUT}"`printf "% 6d" $i`
done
OUTPUT="${OUTPUT}
---------------------------------------------------------------------------------
"

for i in `seq 10 10 ${fanout_max}`
do
OUTPUT="${OUTPUT}Fan-out"`printf "% 4d " $i`
for j in `seq 100 100 ${intval_max}`
do
echo interval:${j} fanout:${i}
./bin/client -addr ${target_addr} -wake ${i} -recvint ${j} -wakeint 200 -sport :7000 -dport :7001 -errorThreshold 0 -checkTimer 60
if [ "x$?" = "x0" ];then
OUTPUT="${OUTPUT}   o  "
else
OUTPUT="${OUTPUT}   x  "
fi
done
OUTPUT="${OUTPUT}
"
done

echo ---------------------------------------------------------------------------------
echo "${OUTPUT}"
