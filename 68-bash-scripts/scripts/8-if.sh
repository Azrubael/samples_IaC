#!/bin/bash
read -p "Enter a number: " NUM
if [ $NUM -gt 100 ]
then
	echo "Hey that's a large number! It is greater than 100."
	echo
	sleep 2
else
	echo "The entered number is less than 100."
	pwd
	echo
fi
echo "Script execution completed successfully."
date