#!/bin/bash

#The script will create a new user with a password, forced to be changed at first login
#
#
#Ask for the user name

read -p 'Please enter new username to create: ' USER_NAME


#Ask for the real person's name

read -p 'Plesae enter the name of the person who this account is for: ' COMMENT


#Ask for the password

read -p 'Enter the password: ' PASSWORD 


#Create the user

useradd -c "${COMMENT}" -m  ${USER_NAME}


#Set the password

echo ${PASSWORD} | passwd --stdin ${USER_NAME}


#Force password change on first login

passwd -e ${USER_NAME}

