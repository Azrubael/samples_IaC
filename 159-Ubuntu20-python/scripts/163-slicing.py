#!/usr/bin/python3

# Slicing of tuples
devops=("Linux", "Vagrant", "Bash Scripting", "AWS", "Jenkins", "Python", "Ansible")
print(devops[3:])
print(devops[3:][-1])
print(devops[3:][-1][:4])

# Slicing of collections
Skills={"DevOps": ("AWS", "Jenkins", "Python", "Ansible"), "Development":["Java", "NodeJS", ".Net", "Ruby", "PHP", "Go"]}
print(Skills["DevOps"][-2])
print(Skills["Development"][1:-2])