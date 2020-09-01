#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This script analyses a CSV file and reports basic statistics
about its columns.

Usage:
  csv_summary [options] CSVFILE 
  csv_summary -h | --help | -V | --version

Options:
    -h            Display this help info
    -v,--verbose  Provide more verbose output
"""
import pandas as pd
from docopt import docopt

args = docopt(__doc__, version='0.1.1')
df = pd.read_csv(args['CSVFILE'])
print(df.describe())
