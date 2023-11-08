#!/bin/bash

if [ -f ./train/data.csv ]
then
	rm ./train/data.csv
fi

if [ -f ./test/data.csv ]
then
	rm ./test/data.csv
fi

awk -f bin.awk winequality-red.csv > dataset.csv

sed 's/;/,/g' dataset.csv > clean_data.csv

rm dataset.csv

NUM=$(wc -l < clean_data.csv)
TRSIZEf=$(echo "$NUM*0.8" | bc)
TRSIZE=${TRSIZEf%.*}
echo $TRSIZE

i=0

while read line
do
	if [ $i -eq 0 ]
	then
		FIRST=$line
	elif [ $i -eq $TRSIZE ]
	then
		echo "$FIRST" >> ./test/data.csv
	fi

	if [ $i -le $TRSIZE ]
	then  
		echo "$line" >> ./train/data.csv
	else
		echo "$line" >> ./test/data.csv
	fi
	i=$((i+1))
done < clean_data.csv
