#!/bin/bash

export PATH=$PWD:$PATH

csvfile=$1.bak
cp -af $1 $csvfile

getNames.sh $csvfile
paste -d, $csvfile names.txt > $1.out

rm -rf names.txt $csvfile
