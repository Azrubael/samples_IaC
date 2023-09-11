#!/bin/bash

counter=0

while [ $counter -lt 1000000 ]
do
  echo "Looping...."
  echo "Value of counter is $counter."
  counter=$(( $counter * 2 ))
  sleep 1
done

echo "Out of the loop"
