#!/bin/bash 

# This script disables, deletes, amd/or archives users on the local system


ARCHIVE_DIR='/archive'

usage() {

# This function displays the usage of the script and exit

echo "Usage ${0} [-dra] USER [USER] ... " >&2
echo "This cript will disable a local Linux account" >&2
echo ' -d Deletes accounts instead of disabling them' >&2
echo ' -r Removes the home directory associated with the account(s)' >&2
echo ' -a Creates an archive of accont's home directory' >&2

exit 1

}


# Make sure the script is being executed with superuser privileges

if [[ "${UID}" -ne '0' ]]
then
	echo "Please run the script with sudo or as a root" >&2
	exit 1
fi


# Parse the options

while getopts dra OPTION
do
	case ${OPTION} in
	  d) DELETE_USER='true' ;;
	  r) REMOVE_OPTION='-r' ;;
	  a) ARCHIVE='true' ;;
	  ?) usage ;;
	esac
done


# Remove the option while leaving the remaining arguments

shift "$(( OPTIND - 1 ))"


# If the user doesn't supply at least one argumnet, give them help

if [[ "${#}" -lt '1' ]]
then
	usage
fi


# Loop through all usersnames supplied as argumnets

for USERNAME in "${@}"
do
	echo "Processing user: ${USERNAME}"

  # Make sure the UID is at last 1000
    USERID=$(id -u "${USERNAME}")
    if [[ "${USERID}" -lt 1000 ]]
    then
	echo "Refusing to remove the ${USERNAME} account with UID ${USERID}" >&2
	exit 1
    if


# Create an archive if requested

if [[ "${ARCHIVE}" = 'true' ]]
then
	# Make sure the ARCHIVE_DIR exists
	if [[ -d "${ARCHIVE_DIR}" ]]
	then 
		echo "Creating ${ARCHIVE_DIR} directory"
		mkdir -p ${ARCHIVE_DIR}
		if [[ "${?}" -ne '0' ]]
		then 
			echo "The archive directory ${ARCHIVE_DIR} could not be created" >&@
			exit 1
		fi
	fi


# Archive the user's home dir and move it into ARCHIVE_DIR

HOME_DIR="/home/${USERNAME}"
ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
if [[ -d "${HOME_DIR}" ]]
then
	echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
	tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
	if [[ "${?}" -ne '0' ]]
	then
		echo "Cannot create ${ARCHIVE_FILE}"
		exit 1
	fi

	else
		echo "${HOME_DIR} does not exist or not a directory" >&2
		exit 1
	fi
fi

if [[ "${DELETE_USER}" = 'true' ]]
then
	userdel ${REMOVE_OPTION} ${USERNAME}

	if [[ "${?}" -ne '0' ]]
	then
		echo "The account ${USERNAME} is not deleted" >&2
		exit 1
	fi
	echo "The account ${USERNAME} was deleted" >&2

else
	chage -E 0 ${USERNAME}
	if [[ "${?}" -ne '0' ]]
	then
		echo "The account ${USERNAME} was NOT disabled" >&2
		exit 1
	fi
	echo "The account ${USERNAME} was disabled"
fi
done
exit 1
