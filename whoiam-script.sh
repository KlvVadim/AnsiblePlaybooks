#!/bin/bash

#Display the UID and username of the user executing the script
#Display if the user is root


#Display UID using reserved bash variable UID

echo "User UID is ${UID}"
#
#
#Display the username

USER_NAME=$(id -un)

#or the same

USER_NAME2=$(whoami)

echo "Your username is ${USER_NAME} or ${USER_NAME2}"
#
#
#Display if the user is root user or not

if [[ "${UID}" -ne 0 ]]
then 
   echo "You are not root"
else
   echo "You are root"

fi
