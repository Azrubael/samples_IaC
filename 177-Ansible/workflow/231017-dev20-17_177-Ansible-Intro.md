# 2023-10-17    13:29
=====================

* 177 - Ansible Introduction
----------------------------
History of Automation
1. Linux Bash scripting / Windows Batch scripting
        Uses mainly for OS tasks
2. Perl / Python / Ruby scripting
        Uses mainly in virtualization, for cloud tasks, for DB task or any building of Automation. The Python got more popular because of its huge libraries where we can get library to automate various kinds of things.
3. PowerShell scripting for Windows specific tasks.
        VMware related automation
4. Configuration management with Puppet
        Puppet wasn't initialy considered as an automation tool, but only managing configuration). 
5. Puppet + Salt Stack (to simplify executing commands on remote machines).
        It generally used to run Puppet agents on remote servers through Salt Stack (an initial setup through Salt Stack) and then most configuration through Puppet.
Puppet was just aautomation tool and there was no programming language over there but with own DSL (domain specific language).
Puppet is built on Ruby, Salt Stack - on Python. But we don't need to writy code or the Ruby code in that.
6. Chef - It came with more manageability and more power to the user.
        We have the power of writing Ruby code through Chef. And there are more templating and more features. Also the graphical user interface was there, so you can generate reports and stuff like that.
# But you have too manu moving parts in the Chef: a server, cliens, workstation. It is a bit complicate so it will be good not in every usecase.
7. Ansible - a configuration management tool.
        Ansible was developed by Michael Dohan in Python and out of all it become the simplest automation tool. It was acquired by Red Hat then. And now we have a lot of things in Ansible (tower, enterprise version etc.)
8. Terraform cloud formation.
        It is a tool which is mostly for cloud automation. But you can do Cloud automation with Ansible too. But Terraform is more cloud automation specific tool.

And also sure there a lot of other automation tools, not so popular.
        
So Ansible came with an idea of simplisity, having a very simple code to manage your huge infrastructure. Initially Ansible was more focused on Linux machines. Automation of Windows with Ansible became possible later.

Popular usecases for Ansible:
- Any system automation (Linux, Windows, web services, databases, services configuration, start/restart services);
- Change management (production server management);
- Provisioning (setup servers from scratch / Cloud provisioning / Launich setup and reconfiguration of instances);
- Large scale Orchestration (combining multiple automation tools and scripts together and execute themin a proper order).
- You can integrate Ansible whith other tools like Jenkins or any other integration tool or service.


ANSIBLE IS SIMPLE and "a very clean one":
-----------------------------------------
+ NO AGENTS
    It don't have any agents. You have servers and you can manage all the machines from those servers. Ansible uses existing connection like ssh for Linux or winRM for Windows or some existing API based modules;
+ NO DATABASES
    It don't have any databases and cmplicated storage. Instead you work with YAML / INI / TXT format. You ave playbooks, scripts and configuration in these very simple formats. The output is written in JSON format.
+ NO COMPLEX SETUP
    It have very simple setup. It is just a Python library (pip install ansible). Of cours you can install Ansible through package managers.
+ NO RESIDUAL SOFTWARE
    So you write the Ansible code, the playbooks, it's going to create some Python scripts for that, execute it on a target and return the output. There's no residual software left on the targets or even on the same machine.
+ YAML
    You don't need programming in any language to do any automation. With Ansible you have playbook in YAML format.
+ API
    Ansible has a lot of modules to do a particular task:
    - URL/Restful Calls (e.g. Cloud)
    - Shell Commands (Bash or PowerShell)
    - Scripts

How does Ansible connects to targets? ---> '177-Ansible_1.png'
As a target it can be a Linux or a Windws server, cloud account, network equipment.
For Linux and Windows Ansible uses the Python modules and Python scripts to connect to the target machine, dump the Python script where it executed and return the output.
But for API task Puthon scripts is going to execute on the control machine locally. You just use the module and you mentioned the destination.

ANSIBLE do all kind of connection and execution behind the scene.
There is no really any architecture of Ansible, see '177-Ansible_architecture.png'.

# So you HAVE to create an inventory file, where you'll have the target machine information (IP address, username, password) and you'll show what kind of module you want to ececute on this host.
# Ansible has lots of built-in modules that are supposed o do a particular task (installing a package or restarting a servoce or taking a snapshot / EBS volume etc.). There about 1000 different modules.

Try to keep your code as simple as possible.