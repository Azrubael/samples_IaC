#!/usr/bin/python3
"""
This script will implement our knowledge on conditions and different datatypes.
"""

print("""This IT organization has various skill sets.
Find out your match.

Please enter capitalized values: 
""")

# list
DevOps = ["Jenkins", "Ansible", "Bash", "Python", "AWS", "Docker", "Kubernetes", "Terraform"]
# tuple
Development = ("Nodejs", "Angularjs", "Java", ".Net", "Python")
# dictionaries
cntr_emp1 = {"Name": "Santa", "Skill": "Blockchain", "Code": 1024}
cntr_emp2 = {"Name": "Rocky", "Skill": "Ai", "Code": 1218}
cntr_emp = [cntr_emp1, cntr_emp2]

usr_skill = input("Enter your desired skill: ")
skill = usr_skill.casefold().capitalize()

# Check in the database if we have this skill
if skill in DevOps:
    print(f"We have {skill} in DevOps Team.")
elif  skill in Development:
    print(f"We have {skill} in Development Team.")
else:
    answer = f"We haven't employees with skill of {skill} in our teams."
    for em in cntr_emp:
        if skill == em["Skill"]:
            answer = f"We have contract employees with skill of {skill}."
            break
    print(answer)