FROM openjdk:11 AS BUILD_IMAGE
RUN apt-get update
RUN apt-get install maven --yes --fix-broken
RUN git clone https://github.com/Azrubael/230903-javacode.git
RUN cd 230903-javacode && mvn install

FROM tomcat:9-jre11

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=BUILD_IMAGE 230903-javacode/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
