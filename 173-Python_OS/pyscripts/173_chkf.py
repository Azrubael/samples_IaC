#!/usr/bin/python3

import os

path = "/tmp/pysys"
if os.path.isdir(path):
    print("It is a direcory.")
elif os.path.isfile(path):
    print("It is a file.")
else:
    print("File or directory doesn't exist.")
