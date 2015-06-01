#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM java:8

ENV ES_PKG_NAME elasticsearch-1.5.0

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

RUN \
  apt-get update && \
  apt-get install -y vim && \
  apt-get install -y nginx && \
  apt-get install -y apache2-utils

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /data/config/elasticsearch.yml
ADD config/default /etc/nginx/sites-available/default
ADD config/user.pwd /data/user.pwd
# Define working directory.
WORKDIR /data

RUN \
  service nginx start

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOST 8000
EXPOSE 9200
EXPOSE 9300
