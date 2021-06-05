#!/bin/bash

filename=$1

rm -rf names.txt
touch names.txt
{
awk -F "\"*,\"*" '{print $5}' $filename | while read line; do
     curl -s http://zinc.docking.org/substances/search/?q=$line | grep "abbr title"  || echo "None" 
done
} > names.txt

sed -i 's/^[^"]*"\([^"]*\)".*/\1/' names.txt
