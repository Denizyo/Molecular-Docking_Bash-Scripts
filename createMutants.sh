#!/bin/bash

structure=$1
structureName=${structure##*/}
structureName=$(echo $structureName | sed 's/\.[^.]*$//')
replacement=$3
replacement=${replacement^^}
aminos=$2
aminos=${aminos^^}

filteredAminos=$(echo $aminos | tr ',' '\n' | grep -v '^$' | sort -rf | uniq -i | sort -k 1,1nr)

for i in $(echo $filteredAminos | tr " " "\n")
do
	chain=$(echo $i | awk -F"[()]" '{print $2}')  	
	amino=$(echo $i | awk -F"[()]" '{print substr($1,1,3)}')
	number=$(echo $i | awk -F"[()]" '{print substr($1,4,length($1)-3)}')	
	echo $chain $amino $number
	python3 $(which PyMOLMutateAminoAcids.py) -m $chain':'$amino$number$replacement -i $structure -o $structureName:$chain:$amino$number$replacement.pdb
done
