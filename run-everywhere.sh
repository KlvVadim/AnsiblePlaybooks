#!/bin/bash
#
# A list of servers, one per line, should be provided as an argument in command line
SERVER_LIST="/root/MyScripts/server.list"


# Options for ssh command.
SSH_OPTIONS='-o ConnectTimeout=5'

usage () {
  # Display the usage of the script and exit.
  echo
  echo "Usage: ${0}" [-nsv] [-f FILE] COMMAND >&2
  echo "Execures COMMAND as a single command on every server on the list" >&2
  echo " -f FILE Use FILE for the list of servers. Default ${SERVER_LIST}." >&2
  echo " -n  Dry run mode. Dusplay the COMMAND that would have been executed and exit" >&2
  echo " -s Execute COMMAND using sudo on the remote server" >&2
  echo " -v Verbose mode"  >&2
  echo
  exit 1
}

# Make sure the script is not executed with superuser privileges.

# if [[ "${UID}" -eq '0' ]]
# then
	# echo "Do not execute the script as a root. Use the -s option instead." >&2
	# usage
# fi


# Prase the options (f option requires an argument and therefore it has ':')

while getopts f:nsv OPTION
do
	case ${OPTION} in
		f) SERVER_LIST="${OPTARG}" ;;
		n) DRY_RUN='true' ;;
		s) SUDO='sudo' ;;
		v) VERBOSE='true' ;;
		?) usage ;;
	esac
done

# Anything that left on command line after we parsed the options should be a command --> shift everything over after the options
# Remove the options while leaving the remaining argument

shift "$(( OPTIND - 1 ))"


# If user doesn't supply at least one argument


if [[ "${#}" -lt 1 ]]
then
	usage
fi


# Anything that remains on the command line is to be treated as a single command

COMMAND="${@}"


# Make sure the SERVER_LIST file exists.

if [[ ! -e "${SERVER_LIST}" ]]
then
        echo "Cannot open server list file: ${SERVER_LIST}" >&2
        exit 1
fi


# Loop through the SERVER_LIST

for SERVER in $(cat "${SERVER_LIST}")
do
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "$SERVER"
	fi
	
	SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"
	
	# If it is a dry run don't execute anything, just echo it
	if [[ ${DRY_RUN} = 'true' ]]
	then
		echo "DRY RUN: $SSH_COMMAND"
	else
		${SSH_COMMAND}
		SSH_EXIT_STATUS="${?}"
		
	  # Capture any non-zero exit status from SSH_COMMAND
	  if [[ "${SSH_EXIT_STATUS}" -ne '0' ]]
	  then
	  EXIT_STATUS="$SSH_EXIT_STATUS"
	  echo "Execution on server $SERVER failed." >&2
	  fi
	fi
done

exit ${SSH_EXIT_STATUS}
