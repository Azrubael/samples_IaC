#!/bin/bash

value=$(ip addr show | grep -v LOOPBACK | grep -ic mtu)
# флаг -v делает исключение для некой строки
# флаг -ic означает 'include' + 'count'. т.е. подсчитывает количество

if [ $value -eq 1 ]
then
  echo "1 Active Network Interface found."
elif [ $value -gt 1 ]
then
  echo "Found Multiple active Interface."
else
  echo "No Active interface found."
fi

