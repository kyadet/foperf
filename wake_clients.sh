#!/bin/bash -x
_server_addr=${1:-10.0.0.6}
_wake=${2:-30}
_recvint=${3:-100}
_wakeint=${4:-200}

nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7000 -dport :7001 1>  ./log/client1.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7002 -dport :7003 1>  ./log/client2.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7004 -dport :7005 1>  ./log/client3.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7006 -dport :7007 1>  ./log/client4.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7008 -dport :7009 1>  ./log/client5.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7010 -dport :7011 1>  ./log/client6.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7012 -dport :7013 1>  ./log/client7.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7014 -dport :7015 1>  ./log/client8.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7016 -dport :7017 1>  ./log/client9.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7018 -dport :7019 1>  ./log/client10.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7020 -dport :7021 1>  ./log/client11.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7022 -dport :7023 1>  ./log/client12.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7024 -dport :7025 1>  ./log/client13.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7026 -dport :7027 1>  ./log/client14.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7028 -dport :7029 1>  ./log/client15.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7030 -dport :7031 1>  ./log/client16.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7032 -dport :7033 1>  ./log/client17.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7034 -dport :7035 1>  ./log/client18.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7036 -dport :7037 1>  ./log/client19.log 2>&1 &
nohup ./bin/client -addr ${_server_addr} -wake ${_wake} -recvint ${_recvint} -wakeint ${_wakeint} -sport :7038 -dport :7039 1>  ./log/client20.log 2>&1 &
