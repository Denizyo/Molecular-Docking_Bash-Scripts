#!/bin/bash

rm -rf *.csv* *.json*

wget "https://zinc.docking.org/substances/subsets/fda.csv?count=all" -O fda.csv
wget "https://zinc.docking.org/substances/subsets/fda.json?count=all" -O fda.json
