#!/bin/bash


# This script demonstrates the difference in using "case" statement instead of "if"

# First is an "if" demonstartion (commented)

## if [[ "${1}" = start ]]
## then
## 	echo "Starting."
## elif [[ "${1}" = stop ]]
## then 
##	echo "Stoping."
## elif [[ "${1}" = Status ]]
## then
##	echo "Status"
## fi


# Second we do the same using "case" statement (commented)

## case "${1}" in
##	start)
##		echo "Starting"
##	;;
##	stop)
##		rcho "Stopping"
##	;;
##	status)
##		echo "Status"
##	;;
## esac


# Now, it is almost same "case" script but being compacted

case "${1}" in
	start) echo 'Starting' ;;
	stop)  echo 'Stopping' ;;
	status|state|--status|--state) echo "Status" ;;

# and for everything different from above we will use *
	*)
		echo 'Supply a valid option' >&2
		exit 1
		;;
esac
