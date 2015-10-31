FROM ubuntu
MAINTAINER Aurélien Thieriot <aurelien@scalar.is>

RUN apt-get install -y curl

ENV TOPBEAT_VERSION=1.0.0-beta4

RUN curl -L -O https://download.elastic.co/beats/topbeat/topbeat_${TOPBEAT_VERSION}_amd64.deb && \
    sudo dpkg -i topbeat_${TOPBEAT_VERSION}_amd64.deb && \
    mv /etc/topbeat/topbeat.yml /etc/topbeat/topbeat.example.yml

ADD topbeat.yml /etc/topbeat/topbeat.yml
ADD start.sh /

CMD /start.sh
