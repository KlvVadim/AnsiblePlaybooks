#!/bin/bash

# This script is done for the log file of unsuccessfull logins which has 3rd column from the end as IPs adrresses from where the attcker is trying to get inside our system
# If there are any IPs with over LIMIT failures, display the count, IP, and location (found by IP)

LIMIT='5'
LOG_FILE="${1}"

# Make sure a file was supplied as an argument

if [[ ! -e "${LOG_FILE}" ]]
then
	echo "Cannot open log file: ${LOG_FILE}" >&2
	exit 1
fi


# Display the CSV header

echo 'Count,IP,Location'


# Loop through the list of failed login attempts and corresponding IP addresses (grep command looks for some pattern about failed logins (= Failed password for) in this log)

grep Failed | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
  # if the number of failed attempts is greater than the limit, display count, IP, and location
  if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then
	LOCATION=$(geoiplookup ${IP} | awk -F ',' '{print $2}')
	echo "${COUNT},${IP},{LOCATION}"
  fi

done

