#!/usr/bin/python3

import os

userlist = ["alpa", "beta", "gamma"]
print("Adding users to current OS")
print("="*30)

# Loop to add user from userlist
for user in userlist:
    exitcode = os.system("id {}".format(user))
    if exitcode != 0:
        print("User {} does not exist. Adding it.".format(user))
        print("-"*20)
        print()
        os.system(("useradd {}".format(user)))
    else:
        print("User {} already exists, skipping it".format(user))
        print("-"*20)
        print()

# Condition to check if group exists or not, if not exist.
grp = "science"
exitcode = os.system("grep {} /etc/group".format(grp))
if exitcode != 0:
    print("Group {} doesn't exist. Adding it.".format(grp))
    print("-"*20)
    print()
    os.system("groupadd {}".format(grp))
else:
    print("Group {} already exist. Skipping it.".format(grp))
    print("-"*20)
    print()

# We don't have to check if any user exists in some group
# because Python will not complain if it isn't so.
for user in userlist:
    print("Adding user '{}' in the '{}' group".format(user, grp))
    os.system("usermod -G {} {}".format(grp, user))
    os.system("id {}".format(user))
    print("-"*20)
    print()

print()
print()
#########################################################
print("Adding a directory...")
print("="*30)
print()

dir_name = "/opt/science_dir"
if os.path.isdir(dir_name):
    print("Directory '{}' already exists, skipping it".format(dir_name))
else:
    os.mkdir(dir_name)

print()
print()
#########################################################
print("Assigning permission and ownership to the directory...")
print("="*30)
print()
os.system("chown :{} {}".format(grp, dir_name))
os.system("chmod 770 {}".format(dir_name))

