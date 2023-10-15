#!/usr/bin/python3

import sys
import ast

def ADD(arg):
    S = 0
    for el in arg:
        try:
            S += ast.literal_eval(el)
        except:
            print(f"The element '{el}' isn't a digital")
    return S

data = sys.argv[1:]
if len(data) > 0:   
    print(ADD(data))
else:
    print(ADD(0))