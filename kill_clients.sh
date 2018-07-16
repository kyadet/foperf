#!/bin/bash

pids=`ps aux | grep [c]lient | awk '{print $2}'`
echo kill ${pids}
kill ${pids}

exit 0
