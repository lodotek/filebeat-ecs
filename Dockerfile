FROM openjdk:8-jre
LABEL maintainer="Chris Montes <lodotek@gmail.com>"

ADD beats.repo /etc/yum.repos.d
ADD docker-entrypoint.sh /
ADD bootstrap.sh /root/bootstrap.sh
RUN /root/bootstrap.sh && rm /root/bootstrap.sh && chmod a+x /docker-entrypoint.sh

VOLUME /var/log

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["filebeat"]
WORKDIR /etc/filebeat

