# Docker Elastic.co Topbeat

Docker image for Elastic Topbeat

# Usage

## Elasticsearch

      docker run -d \
        --links=elasticsearch:elasticsearch \
        --name=topbeat \
        athieriot/topbeat
      
## Logstash

      docker run -d \
        -e PROFILE=logstash \
        --links=logstash:logstash \
        --name=topbeat \
        athieriot/topbeat

## File

      docker run -d \
        -e PROFILE=file \
        -v /path/to/data/:/topbeat/data/ \
        --name=topbeat \
        athieriot/topbeat

## Custom configuration file

      docker run -d \
        -e PROFILE=custom \
        -v /path/to/config/topbeat.yml:/topbeat/config/topbeat.yml \
        --name=topbeat \
        athieriot/topbeat

# More variables

      docker run -d \
        -e HOST=elasticsearch.in.aws.com \
        -e PORT=80 \
        -e INDEX=topbeat \
        -e PROCS=.* \
        -e PERIOD=10 \
        --name=topbeat \
        athieriot/topbeat
