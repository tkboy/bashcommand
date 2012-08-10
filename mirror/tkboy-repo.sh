#!/bin/bash

export GIT="abc"

SUB=`ls -d */` 
PWD=`pwd`
for file in ${SUB}
do
	FILE="$PWD/${file}tkboy-repo.sh"
	if [ -f $FILE ]; then
		echo "$FILE"
		cd $PWD/${file}
		$FILE
		cd $PWD
	fi
done


echo "git = $GIT"


CT=${#GIT[@]}
let CT=CT/4
echo $CT
for (( i = 0; i < CT ; i++ ))
do
	echo ${GIT[i*4+0]}
done



