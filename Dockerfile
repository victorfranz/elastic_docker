#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#
# Original java instalation from https://github.com/gratiartis/dockerfiles/blob/master/oraclejdk8/Dockerfile

# Pull base image.
FROM ubuntu

# Add a repo where OpenJDK can be found.
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

# Auto-accept the Oracle JDK license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

RUN apt-get install -y oracle-java8-installer

ENV ES_PKG_NAME elasticsearch-1.5.0

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

RUN /elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf
RUN /elasticsearch/bin/plugin --install royrusso/elasticsearch-HQ

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
