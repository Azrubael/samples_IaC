# 2023-12-04    16:12
=====================

# See
cd /opt/CODE/DevOpsCompl20/samples_IaC/217-vprofile-docker/vprofile-project/

Now I'm going to setup Jenkins EC2 instance.
* 231204-dev20-23_137-setup-Jenkins&sonarcube.md
------------------------------------------------
[local Ukrainian time 17:46]



* 257 - JenkinsSonar & Docker Integration
-----------------------------------------
# git clone -b cicd-kube https://github.com/devopshydclub/vprofile-project



[timecode 04:09]
Login SonarQube
# http://100.26.173.100/projects
# And generate a new token
> SonarQube> Dashboard > A > My Account > Sequrity > Generate tokens >
    {kube-jenkins: xxx } > Jenkins

Login Jenkins
# http://44.202.137.122:8080
> Jenkins > Dashboard > Manage Jenkins > Plugins > 
    search for 'sonarqube' - SonarQube Scanner: *ON* > 
    search for 'build timestamp' - Build Timestamp: *ON* >
    search for 'Pipeline Maven' - Pipeline Maven Integration: *ON* >
    search for 'pipeline utility' - Pipeline Utility Steps: *ON* >
    INSTALL

> Jenkins > Dashboard > Manage Jenkins > Tools > *Add SonarQube Scanner* >
    {'name': 'sonar481'} > Install from Maven Central: version 4.8.1... >
    *SAVE*
    
> Jenkins > Dashboard > Manage Jenkins > System > SonarQube servers >
    Environment variables - ON > { 'Name': 'sonarK8ube' } >
    { 'Server URL': 'http://172.31.93.138' } >
    Add token > {'Kind': 'secret text'} >
    {'Secret': 'xxx'} >
    {'ID': 'jenkinstoken'; 'Description': 'jenkinstoken'} > SAVE >
    SonarQube servers: MySonarToken > *SAVE*

