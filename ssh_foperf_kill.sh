#!/bin/bash
remote_addr=$1

client=/root/foperf/bin/client
pkill=/bin/pkill

ssh $remote_addr "${pkill} ${client} "

exit 0
