#! /bin/bash
# Author: Andreas Geyer
# Version: 0.2.0

# TODO Check if server(localhost) is running
# TODO Check if 'open' command is present
# TODO Check if 'code' command is present

# Features
#   - open Jira project webpage (python(bs4))
#   - provide auto WP login (python(bs4))

VERSION=0.2.0

# check number of given parameters
if [[ $# -lt 1 ]]; then 
    echo; echo "usage: $0 <project-code> [dir-name]"; 
    echo; echo "you have to be in the directory where your project is stored"
    echo; exit 1
fi

# Project Code and File Structure
PROJECT_CODE=$1
DIR_NAME_PREFIX=${2-"wp-local"}

# Get/define MAMP dir from .zshrc
MAMP_ROOT_DIR=${MY_MAMP_ROOT_DIR:?"No global MAMP directory defined"}

DIR_NAME="$DIR_NAME_PREFIX-$PROJECT_CODE"

# check if MAMP root dir exist and remove suffix from pwd
# exit with error if dir not exists
if [[ ! $PWD =~ \/$MAMP_ROOT_DIR(/.*)?$ ]]; then echo "ERROR"; echo "MAMP root directory ->$MAMP_ROOT_DIR<- not found in work directory \$pwd"; echo; exit 1
fi
PROJECT_PATH=${PWD#*"$MAMP_ROOT_DIR"} 

# Database and Webserver
LOCALHOST="http://localhost:8888"
URL="${LOCALHOST}${PROJECT_PATH}/${DIR_NAME}"

if [[ ! -d "$DIR_NAME" ]]; then echo; echo "Directory $DIR_NAME does not exist."; echo; exit 1;
fi

# Open Google Chrome browser w/ given URL to project
open -a "Google Chrome" "${URL}"
open -a "Google Chrome" "${URL}/wp-admin"
# Open VS Code w/ given project
code "$DIR_NAME"


