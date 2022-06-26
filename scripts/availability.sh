#!/bin/bash

# Set these to whatever you want.
router_ip=192.168.0.1
log_file=/home/zeroring/HomeLab/mystery.log

# Make sure we can write to the log.
touch $log_file
if [ $? != 0 ]; then
    echo "Cannot use $log_file."
    exit 1
fi  

# Redirect output.
exec 1> /dev/null
exec 2>> $log_file

# A function for logging.
print2log () {
    echo $(date +"%D %R ")$@ >>$log_file
}

ping -c 1 $router_ip & wait $!
if [ $? != 0 ]; then
	print2log "Router FAIL"
else 
	print2log "Router OK."
fi

wget -q --spider http://google.com
if [ $? != 0 ]; then
	print2log "Internet FAIL"
else 
	print2log "Internet OK."
fi

ram=$(grep Mem /proc/meminfo | awk '{ printf "%.2f ", $2/1048576 }' \
    | awk '{printf "%.2f GB/%.2f GB", ($1-$3), $3 }')

print2log "RAM: "$ram
print2log "sshd PIDs: "$(ps -o pid= -C sshd)
print2log "running containers: "$(docker ps -q | wc -l)" ( "$(docker ps --format "{{.Names}}" | tr '\n' ' ')")"
