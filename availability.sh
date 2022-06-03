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

# Ping router.
ping -c 1 $router_ip & wait $!

if [ $? != 0 ]; then
	print2log "Ping $router_ip failed."
else 
	print2log "Ping OK."
fi

# Check sshd.
print2log "sshd PIDs: "$(ps -o pid= -C sshd)