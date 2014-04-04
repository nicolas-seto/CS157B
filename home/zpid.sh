#!/bin/bash

# Author: Nic Seto

FILE=URLs.txt
let lineNum=1
let totalPages=0
let totalResultCount=0
while read line ; do
	parity=$(( lineNum % 2 ))
	if [ $parity -eq "1" ] ; then
		URL=$line
	else
		POST_data=$line
		page_content=$(curl -d "$POST_data" "$URL")
		num=$(echo "$page_content" | grep -oP '"numPages":\K\d+')
		count=$(echo "$page_content" | grep -oP '"totalResultCount":\K\d+')
        	(( totalPages += num ))
		(( totalResultCount += count ))
		for (( page=1; page<=$num; page++ )) ; do
                	new_url=$(echo "$URL" | sed "s/\&p=[0-9]\+\&/\&p=${page}\&/g")
                	echo "Downloading from ${new_url}"
			json_content=$(curl -d "${POST_data}" "${new_url}")
			echo $json_content > "${lineNum}_${page}.txt"
			mv "${lineNum}_${page}.txt" json_data/
               		echo $json_content | grep -oP 'zpid_\K\d+' >> zpids.txt
        	done
	fi
	(( lineNum++ ))
done < $FILE
echo "Total pages parsed: ${totalPages}"
echo "Total result count: ${totalResultCount}"
