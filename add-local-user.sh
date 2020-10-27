#!/bin/bash
#
# The script will create a new user on the local system
# You will be prompted to enter the username (login, the person name, and  a password,that will be forced to be changed at first login
# The username, password and host for the account will be displayed
#
#
# Check if you are root user because you need to run useradd

echo "Checking if you are root user and have privileges to run the script"

if [[ ${UID} -eq '0' ]]

	then 
		echo "You are root user"
	else
		echo "You are not root user and the script will stop now"

		exit 1

fi

#
#
# Or you can make this if statement above with -ne 0 and so it will be only one them and mo else 
#
#
#

# Ask for the user name

read -p 'Please enter new username to create: ' USER_NAME


# Ask for the real person's name

read -p 'Plesae enter the name of the person who this account is for: ' COMMENT


# Ask for the password

read -p 'Enter the password: ' PASSWORD 


# Create the user

useradd -c "${COMMENT}" -m  ${USER_NAME}


# Check to see if the useradd command succeeded.
# We are checking exist status of last executed command (which is useradd in this case), if it is not 0 then stop the script 

if [["${?}" -ne '0']]

	then 
		echo "The account creation failed"
		exit 1

fi


# Set the password

echo ${PASSWORD} | passwd --stdin ${USER_NAME}


# Check to see if the passwd command succeeded.
# We are checking exist status of last executed command (which is passwd in this case), if it is not 0 then stop the script 

if [["${?}" -ne '0']]

	then 
		echo "The password setup failed"
		exit 1

fi


# Force password change on first login

passwd -e ${USER_NAME}


# Display the username, password and hostname
# First echo line is for empty line
echo
echo "This info about user's details: "
echo "The user name is ${USER_NAME}"
echo "The password is ${PASSWORD}"
echo "The server is $(hostname)"

exit 0

