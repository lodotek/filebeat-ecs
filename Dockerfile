FROM docker.elastic.co/beats/filebeat:6.2.2
LABEL maintainer="Chris Montes <lodotek@gmail.com>"
USER root
RUN yum install -y wget
RUN wget https://raw.githubusercontent.com/logzio/public-certificates/master/COMODORSADomainValidationSecureServerCA.crt &&  mkdir -p /etc/pki/tls/certs && cp COMODORSADomainValidationSecureServerCA.crt /etc/pki/tls/certs/
COPY filebeat.yml /usr/share/filebeat/filebeat.yml
RUN chown filebeat /usr/share/filebeat/filebeat.yml
USER filebeat