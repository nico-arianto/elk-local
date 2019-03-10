#!/usr/bin/env sh

function overrideConfiguration() {
    local targetFile="$3/$1"
    local backupFile="$3/$1.backup"
    local sourceFile="$2/$1"
    if [ ! -e $targetFile ]; then
        echo "Creates an empty $backupFile"
        touch $backupFile
    fi
    if [ ! -e $backupFile ]; then
        echo "Backup the $targetFile to $backupFile"
        cp $targetFile $backupFile
    fi
    echo "Override the $targetFile"
    cp $sourceFile $targetFile
    sed -i "" 's|{{APPLICATION_DATA_DIR}}|'"$APPLICATION_DATA_DIR"'|g' $targetFile
    sed -i "" 's|{{APPLICATION_LOG_DIR}}|'"$APPLICATION_LOG_DIR"'|g' $targetFile
}

function copyConfiguration() {
    local sourceDir="$DIR/$1"
    local targetDir=$2
    mkdir -p $targetDir
    for config in $sourceDir/*; do
        if [ -f $config ]; then
            overrideConfiguration $(basename $config) $sourceDir $targetDir
        fi
    done
}

DIR="${0%/*}"

source $DIR/environment.env

function configureElasticsearch() {
    echo "Configuring Elasticsearch"
    copyConfiguration elasticsearch/config $ELASTICSEARCH_HOME/config
    printf "\n"
}

function configureLogstash() {
    echo "Configuring Logstash"
    copyConfiguration logstash/config $LOGSTASH_HOME/config
    printf "\n"
}

function configureKibana() {
    echo "Configuring Kibana"
    copyConfiguration kibana/config $KIBANA_HOME/config
    printf "\n"
}

configureElasticsearch
configureLogstash
configureKibana
