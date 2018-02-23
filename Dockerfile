FROM docker.elastic.co/beats/filebeat:6.2.2
LABEL maintainer="Chris Montes <lodotek@gmail.com>"
COPY filebeat.yml /usr/share/filebeat/filebeat.yml
USER root
RUN chown filebeat /usr/share/filebeat/filebeat.yml
USER filebeat