FROM ubuntu:16.04 
MAINTAINER "kd31967@gmail.com"
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr
ADD apache-tomcat-7.0.104.tar.gz /root
COPY target/petclinic.war /root/apache-tomcat-7.0.104/webapps
COPY server.xml /root/apache-tomcat-7.0.104/conf/
ENTRYPOINT /root/apache-tomcat-7.0.104/bin/startup.sh && bash
