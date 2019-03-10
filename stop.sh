#!/usr/bin/env sh

function stopKibana() {
    echo "Stop Kibana"
    local pidFile=/tmp/kibana.pid
    if [ -e $pidFile ]; then
        kill $(cat $pidFile)
    fi
}

function stopElasticsearch() {
    echo "Stop Elasticsearch"
    local pidFile=/tmp/elasticsearch.pid
    if [ -e $pidFile ]; then
        kill $(cat $pidFile)
    fi
}

DIR="${0%/*}"

source $DIR/environment.env

stopKibana
stopElasticsearch
