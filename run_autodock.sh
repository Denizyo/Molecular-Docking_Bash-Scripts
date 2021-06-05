#!/bin/bash

structure=$1
structureName=${structure##*/}
structureName=$(echo $structureName | sed 's/\.[^.]*$//')

ligand=$2
ligandName=${ligand##*/}
ligandName=$(echo $ligandName | sed 's/\.[^.]*$//')

rm -rf *.gpf *.fld *.xyz *.dpf *.log *.map *.bak 'out-'$structureName'-'$ligandName
mkdir -p 'out-'$structureName'-'$ligandName
cd 'out-'$structureName'-'$ligandName
pythonsh ~/autodock/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ../$ligand -o $ligandName.pdbqt > /dev/null 
pythonsh ~/autodock/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py -r ../$structure -o $structureName.pdbqt > /dev/null
pythonsh ~/autodock/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_gpf4.py -l $ligandName.pdbqt -r  $structureName.pdbqt -y > /dev/null
sed -i '/^npts/d' $structureName.gpf
sed -i '1s/^/npts 120 120 120\n/' $structureName.gpf
autogrid4 -p $structureName.gpf -l gridmaps.log > /dev/null
pythonsh ~/autodock/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_dpf4.py -l $ligandName.pdbqt -r $structureName.pdbqt > /dev/null 
sed -i '/seed pid time/d' $ligandName'_'$structureName'.dpf'
sed -i '/small molecule center/{q}'  $ligandName'_'$structureName'.dpf'
echo "epdb                                 #this to evaluate the small molecule" >>  $ligandName'_'$structureName'.dpf'
autodock4 -p   $ligandName'_'$structureName'.dpf' -l scoring_result.log > /dev/null
dockerror=$(grep WARNING scoring_result.log)
if [ ! "$dockerror" == "" ]; then
	exit 1
fi

binding=$(grep "Estimated Free Energy of Binding" scoring_result.log | awk -F ' ' '{print $9}')
inhibition=$(grep "Estimated Inhibition Constant, Ki " scoring_result.log | awk -F ' ' '{print $8}')
ligandNumber=$(echo $ligandName | sed 's/.*\_//')
ligandString=$(echo $ligandName | sed 's/_out_.*//')

cd ..
rm -rf 'out-'$structureName'-'$ligandName
echo $binding $inhibition
