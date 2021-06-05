#!/bin/bash

tmpfolder=/tmp/dockresults
targetfile=outputAll
export PATH=$PWD:$PATH
currentdir=$PWD

rm -rf $tmpfolder
mkdir $tmpfolder
cp -af $1 $tmpfolder/$targetfile

cd $tmpfolder
dos2unix $targetfile > /dev/null 2> /dev/null
cat $targetfile |grep "   1   " | awk '{ print $2 }' > $tmpfolder/1.txt
cat $targetfile |grep "   2   " | awk '{ print $2 }' > $tmpfolder/2.txt
cat $targetfile |grep "   3   " | awk '{ print $2 }' > $tmpfolder/3.txt
cat $targetfile |grep "   4   " | awk '{ print $2 }' > $tmpfolder/4.txt
cat $targetfile |grep "   5   " | awk '{ print $2 }' > $tmpfolder/5.txt
cat $targetfile |grep "   6   " | awk '{ print $2 }' > $tmpfolder/6.txt
cat $targetfile |grep "   7   " | awk '{ print $2 }' > $tmpfolder/7.txt
cat $targetfile |grep "   8   " | awk '{ print $2 }' > $tmpfolder/8.txt
cat $targetfile |grep "   9   " | awk '{ print $2 }' > $tmpfolder/9.txt
cat $targetfile |grep "   1   " | awk '{ print $3 }' > $tmpfolder/1x.txt
cat $targetfile |grep "   2   " | awk '{ print $3 }' > $tmpfolder/2x.txt
cat $targetfile |grep "   3   " | awk '{ print $3 }' > $tmpfolder/3x.txt
cat $targetfile |grep "   4   " | awk '{ print $3 }' > $tmpfolder/4x.txt
cat $targetfile |grep "   5   " | awk '{ print $3 }' > $tmpfolder/5x.txt
cat $targetfile |grep "   6   " | awk '{ print $3 }' > $tmpfolder/6x.txt
cat $targetfile |grep "   7   " | awk '{ print $3 }' > $tmpfolder/7x.txt
cat $targetfile |grep "   8   " | awk '{ print $3 }' > $tmpfolder/8x.txt
cat $targetfile |grep "   9   " | awk '{ print $3 }' > $tmpfolder/9x.txt
paste -d,  1.txt 2.txt 3.txt 4.txt 5.txt  6.txt  7.txt  8.txt  9.txt 1x.txt 2x.txt 3x.txt 4x.txt 5x.txt  6x.txt  7x.txt  8x.txt  9x.txt > output.csv
cd - > /dev/null
cp -af $tmpfolder/output.csv ./
rm -rf $tmpfolder
