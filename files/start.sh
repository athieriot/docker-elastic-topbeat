#!/bin/bash

OUTPUT=${PROFILE:-elasticsearch}

mkdir -p /topbeat/config && mkdir -p /topbeat/data

if [ $OUTPUT == "logstash" ] && [ -z PORT ]; then
  PORT=5044
fi

if [ $OUTPUT != "custom" ]; then
  cp /topbeat/topbeat.${OUTPUT}.yml /topbeat/config/topbeat.yml
  sed -i "s#{PERIOD}#${PERIOD:-10}#g" /topbeat/config/topbeat.yml
  sed -i "s#{PROCS}#${PROCS:-.*}#g" /topbeat/config/topbeat.yml
  sed -i "s#{INDEX}#${INDEX:-topbeat}#g" /topbeat/config/topbeat.yml
  sed -i "s#{HOST}#${HOST:-${OUTPUT}}#g" /topbeat/config/topbeat.yml
  sed -i "s#{PORT}#${PORT:-9200}#g" /topbeat/config/topbeat.yml
  sed -i "s#{SHIPPER_NAME}#${SHIPPER_NAME}#g" /topbeat/config/topbeat.yml
  sed -i "s#{SHIPPER_TAGS}#${SHIPPER_TAGS}#g" /topbeat/config/topbeat.yml
fi

if [ $OUTPUT == "elasticsearch" ] || [ $EXTERNAL_ELASTIC_HOST ]; then
  if [ -z $DRY_RUN ]; then
    # wait for elasticsearch to start up
    ELASTIC_PATH=${EXTERNAL_ELASTIC_HOST:-${HOST:-elasticsearch}}:${EXTERNAL_ELASTIC_PORT:-${PORT:-9200}}
    echo "Configure ${ELASTIC_PATH}"

    counter=0
    while [ ! "$(curl $ELASTIC_PATH 2> /dev/null)" -a $counter -lt 30  ]; do
      sleep 1
      ((counter++))
      echo "waiting for Elasticsearch to be up ($counter/30)"
    done

    curl -XPUT "http://$ELASTIC_PATH/_template/topbeat" -d@/etc/topbeat/topbeat.template.json
  fi
fi

if [ -z $DRY_RUN ]; then
  topbeat -e -v -c /topbeat/config/topbeat.yml
fi
