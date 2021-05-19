#!/bin/bash

# this scripts backs up $BACKUP_LOC folder to $BACKUP_TARGET 
# you can define them at the variables
# Enter a logfile name when you run the script 

#test if variable/argument is an empty string
if [ -z $1 ]
	then
		echo "You need to supply a parameter for the logfile"
		exit 255
fi

# Declare the backup folders 
# LOGFILE is a parameter 
LOGFILE="$1"
BACKUP_LOC="/usr/bin/"
BACKUP_TARGET="/home/$USER/backup-variables"

init () {
#check if dir exists 	
	if [ -d $BACKUP_TARGET ]
		then
			echo "Directory already exists."
			echo "$(date +"%x %r %Z")" >> $LOGFILE
			return 1
		else
			mkdir $BACKUP_TARGET
			echo "$(date +"%x %r %Z")" >> $LOGFILE
			return 0
	fi
	
	
	#echo "Creating backup directory" && mkdir $BACKUP_TARGET 2> /dev/null || echo "Directory already exists."
	#echo "$(date +"%x %r %Z")" >> $LOGFILE
}	

tail () {
	command tail -n $1
}

cleanup () {
	rm -rf $BACKUP_TARGET
	echo "RECEIVED CTRLC" >> /home/$USER/$LOGFILE
	exit
}

if (init)
then
	echo "Directory did not exist"
else
	echo "Directory did exist."
fi	


trap cleanup SIGNIT

#echo "Copying files" && cp -v $BACKUP_LOC $BACKUP_TARGET > $LOGFILE 2>&1

echo "Copying files"
cd $BACKUP_LOC
for i in $(ls); do
	cp -v "$i" $BACKUP_TARGET/"$i"-backup >> /home/$USER/$LOGFILE 2>&1
done


grep -i denied $LOGFILE | tail 2

exit 127