#!/usr/bin/env sh

function startElasticsearch() {
    echo "Start Elasticsearch"
    elasticsearch -d -p /tmp/elasticsearch.pid
}

function startKibana() {
    echo "Start Kibana"
    mkdir -p $APPLICATION_LOG_DIR/kibana
    nohup kibana &
}

DIR="${0%/*}"

source $DIR/environment.env

startElasticsearch
startKibana
