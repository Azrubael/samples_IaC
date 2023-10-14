#!/usr/bin/python3

import time

# For Loop
PLANET = "Earth"
for i in PLANET:
    print("Value if i is now ",i)

print()
VACCINES = ("Moderna", "Pfizer", "Sputnik v", "Covaxin", "AstraZeneca")

for vac in VACCINES:
    print(f"{vac} vaccine provides Immunization against covid19")

print()

# While Loop
x = 0
while x <= 10:
    print("Value of X is:", x)
    print("Looping")
    x+=1
    time.sleep(2)
