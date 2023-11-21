FROM nginx

LABEL "Project"="vprofile-docker"
LABEL "Author"="azrubael"

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY nginxvproapp.conf /etc/nginx/conf.d/vproapp.conf