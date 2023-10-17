from fabric.api import *


def greeting(msg):
    print("Good {}".format(msg))


def system_info():
    """The function to run on a local machine."""
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
    # run("du -ht 10k /home -d3")

    sudo("yum install mariadb-server -y")
    sudo("systemctl start mariadb")
    sudo("systemctl enable mariadb")


def web_setup(WEBURL, DIRNAME):
    """Install a webserver on a local machine. Needs two argumens: WEBURL, DIRNAME."""
    local("apt install zip unzip -u")
    print("_"*40)
    print("Installing dependencies")
    print("_"*40)
    sudo("yum install httpd wget unzip -y")

    print("_"*40)
    print("Start and enable service")
    sudo("systemctl start httpd")
    sudo("systemctl enable httpd")
    print("_"*40)
    
    print("_"*40)
    print("Downloading and pushing website to webservers.")
    local("wget -O website.zip {}".format(WEBURL))
    local("unzip -o website.zip")
    print("_"*40)

    tgdir = "/var/www/html/"
    tgfile = "tooplate.zip"
    with lcd(DIRNAME):
        local("zip -r tooplate.zip *")
        put(tgfile, tgdir, use_sudo=True)

    with cd(tgdir):
        sudo("unzip -o {}".format(tgfile))

    sudo("systemctl restart httpd")
    print("Website setup is done.")
    
