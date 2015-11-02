#!/bin/bash

OUTPUT=${PROFILE:-elasticsearch}

if [ $OUTPUT == "logstash" ] && [ -z PORT ]; then
  PORT=5044
fi

if [ $OUTPUT != "custom" ]; then
  cp /topbeat/topbeat.${OUTPUT}.yml /topbeat/config/topbeat.yml
  sed -i "s#{PERIOD}#${PERIOD:-10}#g" /topbeat/config/topbeat.yml
  sed -i "s#{PROCS}#${PROCS:-.*}#g" /topbeat/config/topbeat.yml
  sed -i "s#{INDEX}#${INDEX:-topbeat}#g" /topbeat/config/topbeat.yml
  sed -i "s#{HOST}#${HOST:-${PROFILE}}#g" /topbeat/config/topbeat.yml
  sed -i "s#{PORT}#${PORT:-9200}#g" /topbeat/config/topbeat.yml
fi

if [ $OUTPUT == "elasticsearch" ] || [ $EXTERNAL_ELASTIC_HOST ]; then
  # wait for elasticsearch to start up
  echo "Configure ${EXTERNAL_ELASTIC_HOST:-${HOST:-elasticsearch}}:${EXTERNAL_ELASTIC_PORT:-${PORT:-9200}}"

  if [ -z $DRY_RUN ]; then
    counter=0
    while [ ! "$(curl ${HOST:-${EXTERNAL_ELASTIC_HOST:-elasticsearch}}:${PORT:-${EXTERNAL_ELASTIC_PORT:-9200}} 2> /dev/null)" -a $counter -lt 30  ]; do
      sleep 1
      ((counter++))
      echo "waiting for Elasticsearch to be up ($counter/30)"
    done

    curl -XPUT 'http://${HOST:-${EXTERNAL_ELASTIC_HOST:-elasticsearch}}:${PORT:-${EXTERNAL_ELASTIC_PORT:-9200}}/_template/topbeat' -d@/etc/topbeat/topbeat.template.json
  fi
fi

if [ -z $DRY_RUN ]; then
  topbeat -e -v -c /topbeat/config/topbeat.yml
fi
