#!/bin/python3

import pandas as pd
from rdkit.Chem import PandasTools
import sys

filename = sys.argv[1]

frame = PandasTools.LoadSDF(filename, includeFingerprints=True)
frame = frame.drop(['ID', 'ROMol'], axis=1)
frame.to_csv('sdf.csv',index=False, header=False)
