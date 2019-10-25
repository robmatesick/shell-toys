#!/bin/bash
######################################################################################################################
# check_public_ip.sh
#############
# Checks the public IP address and logs the changes.
####
# Modification Log:
#  2019-07-01 Initial version.
######################################################################################################################


####################
# Functions

function save_result() {
    local savetof=$1
    local result="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') ${result}" >> ${savetof} 2>&1
}


####################
# Main

# Variables
HISTORY_FILE=/home/pi/check_ip/check_public_ip.history
LAST_RUN_FILE=/home/pi/check_ip/last_run.dat
SAVE_DATA_FLAG=0

# Execute
API_RESULT=$(curl -s https://api.ipify.org | head)

if [ ! -r ${LAST_RUN_FILE} ]; then
    SAVE_DATA_FLAG=1
else
    read LAST_IP < ${LAST_RUN_FILE}
    if [ ! "${LAST_IP}" == "${API_RESULT}" ]; then
        echo "IP "${API_RESULT}" has changed from ${LAST_IP}"
        SAVE_DATA_FLAG=1
    fi
fi

# Save the data
if [ ${SAVE_DATA_FLAG} -eq 1 ]; then
    save_result ${HISTORY_FILE} ${API_RESULT}
    echo "${API_RESULT}" > ${LAST_RUN_FILE} 2>&1
fi
