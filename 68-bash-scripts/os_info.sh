#!/bin/bash
# элементарный скрипт для сбора информации о системе
line="---------------------------------"
echo $line
echo "About OS:"
cat /etc/os-release; echo $line
# echo "About Video:"
# inxi -G; echo $line
echo "Current time: $(date)"; echo $line
echo "UPTIME time"; uptime -p; echo $line
echo "FREE memory"; free -h; echo $line
echo "WHO is logged in"; who; echo $line
echo "Filesystem current state:"
df -h; echo $line
echo "List of home directories with size more than 100M:"
du -ht 100M -d2

