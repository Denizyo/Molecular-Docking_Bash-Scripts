#!/bin/bash

tmpfolder=/tmp/dockresults
targetfile=results.txt
targetfile2=sdf
export PATH=$PWD:$PATH
currentdir=$PWD

rm -rf $tmpfolder
mkdir $tmpfolder
cp -af $1 $tmpfolder/$targetfile
cp -af $2 $tmpfolder/$targetfile2

cd $tmpfolder
dos2unix $targetfile > /dev/null 2> /dev/null
perl -0777 -i -pe 's/\-\-\-\-\-\-\-\-\-\-\-\n\#\#\#\#/\-\-\-\-\-\-\-\-\-\-\-\n   1          0.0      0.000      0.000\n   2          0.0      0.000      0.000\n   3          0.0      0.000      0.000\n\#\#\#\#/igs' $targetfile 
cat $targetfile |grep output | grep pdbqt | grep '==>' | sed -e 's!\[+] Docking Molecule ==> output!!' | sed -e 's!\.pdbqt!!' > $tmpfolder/numbers.txt
cat $targetfile |grep "   1   " | awk '{ print $2 }' > $tmpfolder/1.txt
cat $targetfile |grep "   2   " | awk '{ print $2 }' > $tmpfolder/2.txt
cat $targetfile |grep "   3   " | awk '{ print $2 }' > $tmpfolder/3.txt
paste -d, numbers.txt 1.txt 2.txt 3.txt > output.csv
sort -t"," -k1n,1  output.csv > outputsorted.csv
cat outputsorted.csv | tr -d "[:blank:]" >  outputsorted2.csv
parseSdf.py $targetfile2
paste -d, outputsorted2.csv sdf.csv > $currentdir/output.csv
cd - > /dev/null
rm -rf $tmpfolder
