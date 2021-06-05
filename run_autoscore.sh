#!/bin/bash

trap 'kill -9 $(jobs -p %1)' 2

currentPath=$PWD
dockoutputFile="$currentPath/status.log"
dockresultFile="$currentPath/result.csv"

rm -rf "$dockoutputFile"
touch "$dockoutputFile"
rm -rf "$dockresultFile"
touch "$dockresultFile"


autoscore() {
    if [ -d "$folder" ]; then
		echo "Autoscoring: $folder"
		echo "=================================================="
		cd $folder
		for ligand in *_out_ligand*; do
			ligandName=$(echo "$ligand" | cut -f1 -d".")
			if [ "$ligandName" == "$ligand" ]; then
			     continue
			fi
			echo "Folder: $folder Ligand: $ligandName ligand"
			rm -rf *.gpf *.fld *.xyz *.dpf *.log *.map *.bak 'out-'$ligandName
			mkdir -p 'out-'$ligandName
			cd 'out-'$ligandName
			cp -af ../$ligand ./
			cp -af ../6m0j.* ./
			pythonsh ~/autodock/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -l $ligand -r 6m0j.pdbqt -y \
				|| (echo -e "$ligandName \t\t\t FAIL" >> "$dockoutputFile" && continue)
			sed -i '/^npts/d' 6m0j.gpf
			sed -i '1s/^/npts 60 60 60\n/' 6m0j.gpf
			autogrid4 -p 6m0j.gpf -l gridmaps.log \
				|| (echo -e "$ligandName \t\t\t FAIL" >> "$dockoutputFile" && continue)
			pythonsh ~/autodock/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_dpf4.py -l $ligand -r 6m0j.pdbqt \
				|| (echo -e "$ligandName \t\t\t FAIL" >> "$dockoutputFile" && continue)
			sed -i '/seed pid time/d' $ligandName'_6m0j.dpf'
			sed -i '/small molecule center/{q}' $ligandName'_6m0j.dpf'
			echo "epdb                                 #this to evaluate the small molecule" >>  $ligandName'_6m0j.dpf'
			autodock4 -p  $ligandName'_6m0j.dpf' -l scoring_result.log \
				|| (echo -e "$ligandName \t\t\t FAIL" >> "$dockoutputFile" && continue)
			dockerror=$(grep WARNING scoring_result.log)
			if [ "$dockerror" == "" ]; then
				echo -e "$ligandName \t\t\t PASS" >> "$dockoutputFile"
			else
				echo -e "$ligandName \t\t\t FAIL" >> "$dockoutputFile"
			fi

			binding=$(grep "Estimated Free Energy of Binding" scoring_result.log | awk -F ' ' '{print $9}')
			inhibition=$(grep "Estimated Inhibition Constant, Ki " scoring_result.log | awk -F ' ' '{print $8}')
			ligandNumber=$(echo $ligandName | sed 's/.*\_//')
			ligandString=$(echo $ligandName | sed 's/_out_.*//')

			echo $ligandString','$ligandNumber','$binding','$inhibition >>  "$dockresultFile"
			cd - > /dev/null
		done
		cd "$currentPath"
	fi
}

pids=""
N=16
(
for folder in *; do
    ((i=i%N)); ((i++==0)) && wait
    autoscore "$folder" &
    pids="$pids $!"
done
)

echo $pids
for pid in $pids; do
    wait $pid
done
