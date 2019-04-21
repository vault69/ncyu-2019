#!/bin/bash
set -e

MAPPING_FILE=data/ex0-mapping.txt
INPUT_FILE=ex0.txt

while read -r line; do
	if [ "${line::1}" == "#" ]; then
		continue
	fi

	if [[ "`cat $MAPPING_FILE`" =~ `echo $line | cut -d ',' -f 1,3` ]]; then
		exit 0
	fi
done < "$INPUT_FILE"

echo "Student id and chinese name do not match!"
exit 1
