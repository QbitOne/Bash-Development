#!/bin/bash
# Author: Andreas Geyer
# Version: 0.2.0
# Description: 
# Delete WP installation with connected database

VERSION=0.2.0

# check if wp cli is installed an can be used with 'wp' command
if ! hash wp 2>/dev/null; then echo "ERROR"; echo "WP CLI command not found"; exit 1
fi

# check needed parameters
if [ $# -lt 1 ]; then echo; echo "usage: $0 <project-code> [dir-name]"; echo; exit 1
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

# check if dir name not exists
if [[ ! -d "$DIR_NAME" ]]; then echo "ERROR"; echo "$DIR_NAME does not exist"; echo "Abort process..."; exit 1
fi

# Database and Webserver
LOCALHOST="http://localhost:8888"
URL="${LOCALHOST}${PROJECT_PATH}/${DIR_NAME}"

# prepare unique db name
PROJECT_PATH_FOR_DB=$PROJECT_PATH 
# eliminiate first /, replace / with -, add a suffix -
if [[ ${#PROJECT_PATH_FOR_DB} > 0 ]]; then PROJECT_PATH_FOR_DB=${PROJECT_PATH_FOR_DB#/}; PROJECT_PATH_FOR_DB=${PROJECT_PATH_FOR_DB////-}; PROJECT_PATH_FOR_DB="${PROJECT_PATH_FOR_DB}-"
fi

DB_NAME="${PROJECT_PATH_FOR_DB}${DIR_NAME}"

echo; echo "Delete WordPress"
echo "---------------------------------------------------------"; echo
echo "URL: $URL"; echo
echo "The directory ->${DIR_NAME}<- in ->${PROJECT_PATH}<- will be deleted"; echo
echo "The database ->${DB_NAME}<- will be deleted"; echo
echo "---------------------------------------------------------"; echo

# see https://linuxize.com/post/bash-printf-command/
printf "Do you want to delete WordPress with the above configs? [Y/n]: "
# https://linuxize.com/post/bash-read/
read -r -n 1
echo # blank line
# check if user want to proceed
# NOTE: colon in following line is import since we want to a "yes" 
# if no characater is submitted
if [[ ! ${REPLY:-Y} =~ ^[Yy]$ ]]; then echo "WARNING"; echo "Abort process..."; exit 1
fi

# subprocess
(
    # for cd use always an error handling
    # https://github.com/koalaman/shellcheck/wiki/SC2164 
    cd "$DIR_NAME" || { echo "ERROR"; echo "Wrong Directory or does not exist"; exit 1; }

    # delete DB associated with WP
    wp db drop --yes
)
rm -rf "$DIR_NAME"
echo "WordPress was successfully deleted"