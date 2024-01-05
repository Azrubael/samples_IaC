# 2024-01-05  10:08
===================


* 277 - Init
------------

# Working with AWS CloudFormation templates
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html

> AWS > Documentation > AWS CloudFormation > User Guide >
  > Working with templates > Template anatomy > Metadata >
  > AWS::CloudFormation::Init

# AWS::CloudFormation::Init
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html

Below we're getting deal with Metadata.
Вы можете использовать дополнительный раздел «Метаданные», чтобы включить произвольные объекты JSON или YAML, предоставляющие подробную информацию о шаблоне. Например, вы можете включить сведения о реализации шаблона для конкретных ресурсов.

Используйте тип AWS::CloudFormation::Init, чтобы включить метаданные в экземпляр Amazon EC2 для вспомогательного сценария cfn-init. Если ваш шаблон вызывает сценарий cfn-init, он ищет метаданные ресурса, находящиеся в ключе метаданных AWS::CloudFormation::Init.

When you're using EC2 instances AWS::CloudFormation::Init can be really helpful to initialize your instance or you can provision your EC2 instance with some with some data, like to install packages, push some files, start service etc.

# cfn-init - there is a helper script
# cfn-init supports all metadata types for Linux systems. It supports metadata types for Windows with conditions that are described in the sections that follow.
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-init.html


# YAML Syntax example
---
Resources: 
  MyInstance: 
    Type: AWS::EC2::Instance
    Metadata: 
      AWS::CloudFormation::Init: 
        config: 
          packages: 
            :
          groups: 
            :
          users: 
            :
          sources: 
            :
          files: 
            :
          commands: 
            :
          services: 
            :
    Properties: 
      :


Вы можете создать несколько наборов конфигураций и вызвать серию их, используя сценарий cfn-init. Каждый набор конфигураций может содержать список ключей конфигурации или ссылки на другие наборы конфигураций. Например, следующий фрагмент шаблона создает три набора конфигураций. Первый набор конфигурации, test1, содержит один ключ конфигурации с именем 1. Второй набор конфигурации, test2, содержит ссылку на набор конфигурации test1 и один ключ конфигурации с именем 2. Третий набор конфигурации, по умолчанию, содержит ссылку на набор конфигурации test2.
# Mutliple configsets example:
---
AWS::CloudFormation::Init:
  1:
    commands:
      test:
        command: "echo \"$MAGIC\" > test.txt"
        env:
          MAGIC: "I come from the environment!"
        cwd: "~"
  2:
    commands:
      test:
        command: "echo \"$MAGIC\" >> test.txt"
        env:
          MAGIC: "I am test 2!"
        cwd: "~"
  configSets: 
    test1:
      - "1"
    test2:
      - ConfigSet: "test1"
      - "2"
    default:
      - ConfigSet: "test2"



# An example for Linux
The following Linux snippet configures the services as follows:
- The nginx service will be restarted if either /etc/nginx/nginx.conf or /var/www/html are modified by cfn-init.
- The php-fastcgi service will be restarted if cfn-init installs or updates php or spawn-fcgi using yum.
- The sendmail service will be stopped and disabled using systemd.
---
services:
  sysvinit:
    nginx:
      enabled: "true"
      ensureRunning: "true"
      files:
        - "/etc/nginx/nginx.conf"
      sources:
        - "/var/www/html"
    php-fastcgi:
      enabled: "true"
      ensureRunning: "true"
      packages:
        yum:
          - "php"
          - "spawn-fcgi"
  systemd:
    sendmail:
      enabled: "false"
      ensureRunning: "false"



# An example with S3 Bucket
# The following example downloads a tarball from an S3 bucket and unpacks it into /etc/myapp:
---
sources:
  /etc/myapp: "https://s3.amazonaws.com/mybucket/myapp.tar.gz"


SO FOR BASIC SERVICE SETUP YOU DON'T NEED TO USE ANY AUTOMATION TOOL LIKE ANSIBLE, CHEF of anything or even Bash scripts or Python scripts.
You can use metadata and initial helper script and it can provision averything for you as much as it can do. And anyway it has the support for commands so you can just run commands as well.


  $ vaim init.yaml
---
...


# So let's setup a CloudFormation stack:
> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > init.yaml >
  Next > *Create stack* > Submit

# After stack gets greated, check your outputs section:
> AWs > CloudFormation > Stacks > imran-outputs > Outputs >
  > PrintSomeINFO = ec2-34-229-207-167.compute-1.amazonaws.com

# Check our WebServer
http://ec2-3-84-133-31.compute-1.amazonaws.com/
# Gymso Fitness  -  Home

# Check out test page
http://ec2-3-84-133-31.compute-1.amazonaws.com/hello.html
Welcome to Cloudformatio!
This site is deployed by AWS CloudFormation.



