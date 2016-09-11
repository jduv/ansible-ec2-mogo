#~/bin/bash
echo "+-------------------------------------------------------------+"
echo "| This script requires all keys to be in the keys directory.  |"
echo "| After entering the password, this script will decrypt all   |"
echo "| PEM files in the keys directory. Please do NOT check these  |"
echo "| files into source control.                                  |"
echo "+-------------------------------------------------------------+"

if ! [ "$(ls -A keys/*.pem.encrypted)" ]
	then
		echo "Target directory is empty, cannot continue."
     	exit 1
fi

read -s -p "Password: " PASSWORD
echo

# fail if openssl bails
for f in keys/*.pem.encrypted
do
	# do the thing
	echo "Decrypting $f..."
	FILENAME=$(sed -e 's|.pem.encrypted|.pem|' <<< $f)
	openssl aes-256-cbc -salt -a -d -in $f -out $FILENAME -k $PASSWORD

	if [ $? -ne 0 ]
		then
		echo "Failure to decrypt file, exiting..."

		# Clean up the bad file
		if [ -f $FILENAME ]
			then
				rm -rf $FILENAME
		fi

		# Bail
		exit 1
	fi
done