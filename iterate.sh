#!/bin/bash

export PATH=~/autodock/autodock_vina_1_1_2_linux_x86/bin:$PATH

nameOfTheCompound=$1
numberOfIterations=$2

END=100


rm -rf $nameOfTheCompound
mkdir -p $nameOfTheCompound
cp -af conf_$nameOfTheCompound.txt $nameOfTheCompound/conf.txt
cp -af 6m0j.pdb $nameOfTheCompound
cp -af 6m0j.pdbqt $nameOfTheCompound
cp -af $nameOfTheCompound.pdbqt $nameOfTheCompound
cd $nameOfTheCompound


touch outputAll
for (( i=1; i<=$END; i++ ))
do
   echo "Iteration: $i / $NumberOfIterations"
   vina --config conf.txt --log logSO_$i.txt
   mv vina_outSO.pdbqt out$i.pdbqt
   cat logSO_$i.txt >> outputAll
done

