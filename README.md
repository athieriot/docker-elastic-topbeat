# Docker Elastic.co Topbeat

Docker image for Elastic Topbeat

# Usage

### Elasticsearch

      docker run -d \
        --links=elasticsearch:elasticsearch \
        --name=topbeat \
        athieriot/topbeat
      
### Logstash

      docker run -d \
        -e PROFILE=logstash \
        --links=logstash:logstash \
        --name=topbeat \
        athieriot/topbeat

### File

      docker run -d \
        -e PROFILE=file \
        -v /path/to/data/:/topbeat/data/ \
        --name=topbeat \
        athieriot/topbeat

### Custom configuration file

      docker run -d \
        -e PROFILE=custom \
        -v /path/to/config/topbeat.yml:/topbeat/config/topbeat.yml \
        --name=topbeat \
        athieriot/topbeat

# More variables

### General

      docker run -d \
        -e HOST=elasticsearch.in.aws.com \
        -e PORT=80 \
        -e INDEX=topbeat \
        -e PROCS=.* \
        -e PERIOD=10 \
        -e SHIPPER_NAME=super-app \
        -e SHIPPER_TAGS="qa", "db" \
        --name=topbeat \
        athieriot/topbeat

### Elasticsearch template configuration

In the event you are usage a custom configuration or logstash but want to add Topbeat templates to your own Elasticsearch instance:

      docker run -d \
        -e PROFILE=logstash \
        -e EXTERNAL_ELASTIC_HOST=my.elasticsearch.com \
        -e EXTERNAL_ELASTIC_PORT=9200 \
        --links=logstash:logstash \
        --name=topbeat \
        athieriot/topbeat
