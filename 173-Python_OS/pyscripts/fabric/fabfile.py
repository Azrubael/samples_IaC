from fabric.api import *

def greeting(msg):
    print("Good {}".format(msg))

def system_info():
    """The function to run on a local machine"""
    print("Disk space -------------------------------")
    local("df -h")
    print("RAM size ---------------------------------")
    local("free -m")
    print("System uptime ----------------------------")
    local("uptime")

def remote_exec():
    """The function to run on a remote machine."""
    print("Get System Info --------------------------")
    run("hostname")
    run("uptime")
    # run("ps -eF")
    # run("du -ht 1M /home -d3")
    
    sudo("yum install mariadb-server -y")
    sudo("systemctl start mariadb")
    sudo("systemctl enable mariadb")

