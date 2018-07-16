#!/bin/bash

pids=`ps aux | grep [r]elay | awk '{print $2}'`
echo kill ${pids}
kill ${pids}

exit 0
