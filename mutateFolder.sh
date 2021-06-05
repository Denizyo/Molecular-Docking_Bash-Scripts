#!/bin/bash

structure=$1
structureName=${structure##*/}
structureName=$(echo $structureName | sed 's/\.[^.]*$//')
replacement=$2
replacement=${replacement^^}

shopt -s nullglob
for i in *.txt; do
    poseName=$(echo $i | sed 's/\.[^.]*$//')
    residues="$(cat $i)"
    rm -rf $poseName
    mkdir -p $poseName
    cd $poseName
    mutateAndScore.sh ../$structure ../$poseName.pdb "$residues" $replacement
    cd ..
done
