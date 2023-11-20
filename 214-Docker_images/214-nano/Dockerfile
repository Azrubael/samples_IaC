FROM ubuntu:20.04
LABEL "Author"="Azrubael"
LABEL "Project"="nano"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install git -y
RUN apt install apache2 -y
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80

# WORKDIR is just for example, it's not needed
WORKDIR /var/www/html
VOLUME /var/log/apache2
# ADD will untar the archive
ADD nano.tar.gz /var/www/html

# COPY will just load the archive without extraction
# COPY nano.tar.gz /var/www/html
