#~/bin/bash
echo "+---------------------------------------------------------------+"
echo "| This script requires all keys to be in the keys directory.    |"
echo "| Enter a password to encrypt all unencrypted PEM files in the  |"
echo "| keys directory. Unencrypted PEM files will be deleted after   |"
echo "| encrypted. You may check in encrypted PEM files.              |"
echo "+---------------------------------------------------------------+"

if ! [ "$(ls -A keys/*.pem)" ]
	then
		echo "Target directory has no PEM files, cannot continue."
     	exit 1
fi

read -s -p "Password: " PASSWORD
echo

# fail if openssl bails
set -e
for f in keys/*.pem
do
	# do the thing
	echo "Encrypting $f..."
	openssl aes-256-cbc -salt -a -e -in $f -out $f.encrypted -k $PASSWORD

	if [ -f $f.encrypted ]
		then
			rm -rf $f
	fi
done