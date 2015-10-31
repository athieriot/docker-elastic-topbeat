#!/bin/bash

#TODO: Make logstash configurable

# wait for elasticsearch to start up
# - https://github.com/elasticsearch/kibana/issues/3077
counter=0
while [ ! "$(curl elasticsearch:9200 2> /dev/null)" -a $counter -lt 30  ]; do
  sleep 1
  ((counter++))
  echo "waiting for Elasticsearch to be up ($counter/30)"
done

curl -XPUT 'http://elasticsearch:9200/_template/topbeat' -d@/etc/topbeat/topbeat.template.json

topbeat -e -v
