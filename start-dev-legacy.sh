#! /bin/bash
# Author: Andreas Geyer
# Version: 0.1.1

# TODO Check if server(localhost) is running
# TODO Check if 'open' command is present
# TODO Check if 'code' command is present

# Features
#   - Ensprechende Jira Projekt Webpage öffnen (evtl mit python(bs4) umzusetzen)
#   - Direkt in WP einloggen (evtl mit python(bs4) umzusetzen)

VERSION=0.1.1

# Get/define MAMP dir from .zshrc
MAMP_ROOT_DIR=${MY_MAMP_ROOT_DIR:?"No global MAMP directory defined"}

directory="$MAMP_ROOT_DIR"
path="${HOME}/${directory}"
base="wp-local"
project="${base}-${1}"
port="8888"
host="localhost"
url="http://${host}:${port}/${project}"

function usage {
    echo # empty line
    echo "usage: $0 project-name"
    echo "-------------------------------------------"
    echo "  project-name   ->   Short name of a project e.g. qbo"
    echo # empty line
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage; exit 1;
fi

if [[ ! -d "${path}" ]]; then
    echo "Directory $DIR does not exist."; exit 1;
fi

open -a "Google Chrome" "${url}"
open -a "Google Chrome" "${url}/wp-admin"
code "${path}/${project}"


