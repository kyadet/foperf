#!/bin/bash
scenario_file=$1

# check param.
if [ "x$scenario_file" = "x" ];then
  echo require scenario file.
fi

if [ ! -e $scenario_file ];then
  echo not found scenario file.
fi

# prepare logics.
scenario_name="${scenario_file%.*}"
workdir="${scenario_file%.*}"
logfile=${work_dir}/${scenario_name}.log
source $scenario_file
cat $scenario_file | tee ${logfile}
rm -rf ${work_dir}
mkdir -p ${work_dir}

# global variable.
load_index=0

# functions.
plog(){
  echo "$*" | tee ${logfile}
}

die(){
  plog "$1" 
  plog "error." 
  exit 1
}

quit(){
  plog "$1"
  exit 0
}

banner(){
  plog "        "
  plog "    ${1}" 
  plog "        "
}

waitfor(){
  max=$1
  plog "waitfor"
  for i in `seq 0 ${max}`
  do
    echo -n . | tee ${logfile}
    sleep 1
  done
}

create_result_header(){
  header="intval(ms) "
  for i in `seq 100 100 $1`
  do
    header="${header}"`printf "% 6d" $i`
  done
  header="${header}
---------------------------------------------------------------------------------
"
  echo ${header}
}

load(){
  target_addr=$1
  recv_intval=$2
  list=$3
  wake=$4
  for i in $list
  do
    ./ssh_foperf_start.sh ${i} ${target_addr} ${load_index} ${wake} ${recv_intval} ${wake_intval} ${sport} ${dport} ${error_threshold} ${check_timer} | tee ${logfile}
    load_index=$((${load_index} + ${wake}))
  done
}

# main logics.
plog initializing...
for i in ${load1}${load2}${load3}${load4}
do
  ./ssh_foperf_kill.sh $i
  ./ssh_dstat_kill.sh $i
done
plog ok.

plog start performance monitoring...
for i in ${load1}${load2}${load3}${load4}
do
  ./ssh_dstat_start.sh $i
done
plog ok.

OUTPUT=`create_result_header ${intval_max}`

for i in `seq ${start_fanout} ${add_step} ${fanout_max}`
do
  OUTPUT="${OUTPUT}Fan-out"`printf "% 4d " $i`
  for j in `seq 100 100 ${intval_max}`
  do
    load_index=0
    wake_base=$(($i / ${total_count}))
    res_val=0
    timer=$timermax
    plog interval:${j} fanout:${i}

    wake=$(($wake_base * $load1_ratio))
    load $target_addr $recv_intval "$load1" $wake

    wake=$(($wake_base * $load2_ratio))
    load $target_addr $recv_intval "$load2" $wake

    wake=$(($wake_base * $load3_ratio))
    load $target_addr $recv_intval "$load3" $wake

    wake=$(($wake_base * $load4_ratio))
    load $target_addr $recv_intval "$load4" $wake

    plog ok.
    waitfor 3
    
    plog start test...
    while true
    do
      jobs_list=`jobs | awk '{print $1}' | awk -F']' '{print $1}' | awk -F'[' '{print $2}'`
      jobs_count=`echo "${jobs_list}" | wc -l`
      if [ ${jobs_count} -lt ${total_count} ];then
        res_val=1
        echo -n ${jobs_count}, | tee ${logfile}
        echo failed | tee ${logfile}
        break
      fi
      timer=$(($timer - 1))
      sleep 1
      echo -n ${jobs_count}, | tee ${logfile}
      if [ "x${timer}" = "x0" ];then
        echo passed | tee ${logfile}
        break
      fi
    done
    
    jobs_list=`jobs | awk '{print $1}' | awk -F']' '{print $1}' | awk -F'[' '{print $2}'`
    for i in $jobs_list
    do
      waitfor 3
      kill %"${i}" || : | tee ${logfile}
    done
    
    jobs_list=`jobs | awk '{print $1}' | awk -F']' '{print $1}' | awk -F'[' '{print $2}'`
    jobs_count=`echo "${jobs_list}" | wc -l`
    if [ "x${jobs_count}" != "x0" ];then
      plog "job count is not 0 ... ${jobs_count}, force kill."
      /usr/bin/ps -ef | grep [f]operf | grep [c]lient | awk '{print $2}' | xargs kill -9 2>/dev/null 1>&2 || : | tee ${logfile}
    fi
    
    OUTPUT="${OUTPUT}  `printf '%02d' $timer` "
    if [ "x$res_val" = "x0" ];then
      OUTPUT="${OUTPUT}  o "
    else
      OUTPUT="${OUTPUT}  x "
    fi
  done
  OUTPUT="${OUTPUT}
"
  waitfor 15
done

for i in ${load1}${load2}${load3}${load4}
do
  ./ssh_foperf_kill.sh $i | tee ${logfile}
  ./ssh_dstat_kill.sh $i | tee ${logfile}
done

for i in ${load1}${load2}${load3}${load4}
do
  ./ssh_foperf_end.sh $i ${work_dir}/ | tee ${logfile}
  ./ssh_dstat_end.sh $i ${work_dir}/ | tee ${logfile}
done

plog archiving result files...
tar zcvf ${scenario_name}.tar.gz ${work_dir}/ | tee ${logfile}

plog "---------------------------------------------------------------------------------"
plog "${OUTPUT}"

quit "success."
