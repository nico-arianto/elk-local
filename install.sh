#!/usr/bin/env sh

function get_filename() {
    echo "${1##*/}"
}

function get_downloaded_filename() {
    filename=$(get_filename $1)
    echo $DOWNLOAD_DIR/$filename
}

function download_binary() {
    echo "Trying to download $1"
    download_filename=$(get_downloaded_filename $1)
    local file_exist=$([[ -e $download_filename ]] && echo 'true' || echo 'false')
    if [ "$file_exist" == "true" ]; then
        echo "File was downloaded in $download_filename"
        file_md5=$(md5 -q $download_filename)
        if [ "$file_md5" != "$2" ]; then
            echo "MD5 checksum for $download_filename was invalid"
            rm $download_filename
            file_exist='false'
        fi
    fi
    if [ "$file_exist" == "false" ]; then
        echo "Downloading to $download_filename"
        curl -R $1 -o $download_filename
    fi
    printf "\n"
}

function get_foldername() {
    echo "${1%%/*}"
}

function extract_binary() {
    echo "Trying to extract $1"
    download_filename=$(get_downloaded_filename $1)
    head_item=$(tar -tf $download_filename | head -n 1)
    extract_foldername=$(get_foldername $head_item)
    extract_dirname=$APPLICATION_DIR/$extract_foldername
    if [ -d $extract_dirname ]; then
        echo "File was extracted in $extract_dirname"
    else
        echo "Extracting to $extract_dirname"
        if [[ $download_filename =~ \.t?gz$ ]]; then
            tar -xvf $download_filename -C $APPLICATION_DIR
        elif [[ $download_filename =~ \.zip$ ]]; then
            unzip $download_filename -d $APPLICATION_DIR
        else
            echo "Failed to extract because of unsupported filetype"
        fi
    fi
    printf "\n"
}

DIR="${0%/*}"

source $DIR/version.info
source $DIR/package.info
source $DIR/directory.info

declare -a packages=(
    "$ELASTICSEARCH_BINARY|$ELASTICSEARCH_MD5"
    "$LOGSTASH_BINARY|$LOGSTASH_MD5"
    "$KIBANA_BINARY|$KIBANA_MD5"
)

mkdir -p $DOWNLOAD_DIR
mkdir -p $APPLICATION_DIR

for package in "${packages[@]}"
do
    binary="${package%%|*}"
    binary_checksum="${package##*|}"
    download_binary $binary $binary_checksum
    extract_binary $binary
done
