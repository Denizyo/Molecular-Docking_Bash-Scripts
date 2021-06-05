#!/bin/bash

structure=$1
structureName=${structure##*/}
structureName=$(echo $structureName | sed 's/\.[^.]*$//')
pose=$2
poseName=${pose##*/}
poseName=$(echo $poseName | sed 's/\.[^.]*$//')
replacement=$4
replacement=${replacement^^}
aminos=$3
aminos=${aminos^^}

filteredAminos=$(echo $aminos | tr ',' '\n' | grep -v '^$' | sort -rf | uniq -i | sort -k 1,1nr)

originalValue=$(run_autodock.sh $structure $pose | awk '{print $1;}')
echo $structureName "&" $poseName "- original: " $originalValue
echo "========================================================="

rm -rf $poseName.csv
for i in $(echo $filteredAminos | tr " " "\n")
do
(	chain=$(echo $i | awk -F"[()]" '{print $2}')
	amino=$(echo $i | awk -F"[()]" '{print substr($1,1,3)}')
	number=$(echo $i | awk -F"[()]" '{print substr($1,4,length($1)-3)}')	
	rm -rf $structureName:$chain:$amino$number$replacement.pdb
	python3 $(which PyMOLMutateAminoAcids.py) -m $chain':'$amino$number$replacement -i $structure -o $structureName:$chain:$amino$number$replacement.pdb   &>/dev/null
	output=$(run_autodock.sh $structureName:$chain:$amino$number$replacement.pdb $pose)
	echo $chain $number   $amino '=>' $replacement ":"    $originalValue "=>" $(echo $output |awk '{print $1;}')
	echo $structureName,$poseName,$chain,$number,$amino,$replacement,$originalValue,$(echo $output |awk '{print $1;}'),$(echo $output |awk '{print $2;}') >> $poseName.csv
) &
done
wait
echo ""
