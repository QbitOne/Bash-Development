#!/bin/bash
# Author: Andreas Geyer
# Version: 0.1.1
# Description: 
# Remote WordPress migration via SSH

VERSION=0.1.1

# check if wp cli is installed an can be used with 'wp' command
if ! hash wp 2>/dev/null; then echo "ERROR"; echo "WP CLI command not found"; exit 1
fi

# check needed parameters
if [ $# -lt 3 ]; then 
    echo; echo "usage: $0 <domain> <ssh-user> <project-code> [remote-path] [dir-name]"; echo; 
    echo "<domain>          e.g. domain.de"
    echo "<ssh-user>        e.g. user123"
    echo "<project-code>    e.g. pjc"
    echo "[remote-path]     -> /html/wordpress/"
    echo "[dir-name]        -> wp-local"
    echo; exit 1
fi

# Project Code and File Structure
REMOTE_DOMAIN=$1
SSH_USER=$2
PROJECT_CODE=$3
REMOTE_PATH=${4-"/html/wordpress/"}
DIR_NAME_PREFIX=${5-"wp-local"}

# Get/define MAMP dir from .zshrc
MAMP_ROOT_DIR=${MY_MAMP_ROOT_DIR:?"No global MAMP directory defined"}

DIR_NAME="$DIR_NAME_PREFIX-$PROJECT_CODE"

REMOTE_URL="$SSH_USER@$REMOTE_DOMAIN:$REMOTE_PATH"

# check if MAMP root dir exist and remove suffix from pwd
# exit with error if dir not exists
if [[ ! $PWD =~ \/$MAMP_ROOT_DIR(/.*)?$ ]]; then echo "ERROR"; echo "MAMP root directory ->$MAMP_ROOT_DIR<- not found in work directory \$pwd"; echo; exit 1
fi
PROJECT_PATH=${PWD#*"$MAMP_ROOT_DIR"} 

# check if dir name already exists
if [[ -d "$DIR_NAME" ]]; then echo "ERROR"; echo "$DIR_NAME already exists here"; echo "Abort process..."; exit 1 
fi

# Database and Webserver
LOCALHOST="http://localhost:8888"
URL="${LOCALHOST}${PROJECT_PATH}/${DIR_NAME}"

# prepare project path for unique db name
PROJECT_PATH_FOR_DB=$PROJECT_PATH 
# eliminiate first /, replace / with -, add a suffix -
if [[ ${#PROJECT_PATH_FOR_DB} > 0 ]]; then PROJECT_PATH_FOR_DB=${PROJECT_PATH_FOR_DB#/}; PROJECT_PATH_FOR_DB=${PROJECT_PATH_FOR_DB////-}; PROJECT_PATH_FOR_DB="${PROJECT_PATH_FOR_DB}-"
fi

DB_NAME="${PROJECT_PATH_FOR_DB}${DIR_NAME}"

echo; echo "Remote WordPress migration via SSH"
echo "---------------------------------------------------------"; echo
echo "Domain: $REMOTE_DOMAIN"; echo
echo "SSH user: $SSH_USER"; echo
echo "Remote path: $REMOTE_PATH"; echo
echo "Remote URL: $REMOTE_URL"; echo
echo "---------------------------------------------------------"; echo
echo "New URL: $URL"; echo
echo "A new directory ->${DIR_NAME}<- in ->${PROJECT_PATH}<- will be created"; echo
echo "A new database ->${DB_NAME}<- will be created"; echo
echo "---------------------------------------------------------"; echo

# see https://linuxize.com/post/bash-printf-command/
printf "Do you want to proceed the migration? [Y/n]: "
# https://linuxize.com/post/bash-read/
read -r -n 1
echo # blank line
# check if user want to proceed
# NOTE: colon in following line is import since we want to a "yes" 
# if no characater is submitted
if [[ ! ${REPLY:-Y} =~ ^[Yy]$ ]]; then echo "WARNING"; echo "Abort process..."; exit 1
fi

# start creating directory and installation of WP
mkdir "$DIR_NAME"
(
    # # for cd use always an error handling
    # # https://github.com/koalaman/shellcheck/wiki/SC2164 
    cd "$DIR_NAME" || { echo "ERROR"; echo "Problem with new directory $DIR_NAME"; exit 1; }
    
    # Do not use --skip-content flag b/c this not only skips the themes and plugins but also
    # deletes the themes and plugins directory and the index.php file in the wp-content directory.
    # Solution: load content but delete if afterwards with other wp-cli commands
    wp core download --locale=de_DE 

    # MAMP default settings with given database name
    wp config create --dbname="$DB_NAME" --dbuser=root --dbpass=root --dbhost=127.0.0.1:8889

    wp config set WP_SITEURL "$URL"
    wp config set WP_HOME "$URL"
    wp config set AUTOSAVE_INTERVAL 300
    wp config set WP_POST_REVISIONS 5
    wp config set EMPTY_TRASH_DAYS 7
    wp config set WP_DEBUG 1
    wp config set WP_DEBUG_LOG 1
    wp config set WP_DEBUG_DISPLAY 1

    wp db create

    wp core install --url="$URL" --title=TestSite --admin_user=admin --admin_password=admin --admin_email=42@qbitone.de --skip-email

    wp user create "andreas" "andreas@qbitone.de" --role='administrator' --send-email="n" --user_pass="wordpress"
    wp user create "michael" "michael@qbitone.de" --role='administrator' --send-email="n" --user_pass="wordpress"

    # Delete admin user, we do not need it anymore
    wp user delete 1 --reassign=2 --yes

    wp theme delete --all
    wp plugin delete --all 

    # Dry run for remote WP download
    printf "\nDry run to test connection:"
    echo # blank line
    rsync -avczP --dry-run --exclude-from="$HOME/Nextcloud/dev/wp-core-files.txt" --exclude="wp-config.php" --exclude=".htaccess" --exclude="cgi-bin" --exclude="backup*" "$REMOTE_URL" .
    if [ ! "$?" -eq "0" ]; then echo "Error"; echo "Abort process..."; exit 1 
    fi

    # Actual run for remote WP downlaod
    printf "\nDownload remote WP files:"
    echo # blank line
    rsync -avczP --exclude-from="$HOME/Nextcloud/dev/wp-core-files.txt" --exclude="wp-config.php" --exclude=".htaccess" --exclude="cgi-bin" --exclude="backup*" "$REMOTE_URL" .
    if [ ! "$?" -eq "0" ]; then echo "Error"; echo "Abort process..."; exit 1 
    fi

    # Migrate database
    printf "\nMigrate database:"
    echo # blank line
    wp db export --ssh="$REMOTE_URL" --add-drop-table - | wp db import -

    wp plugin deactivate --skip-plugins --all 

    wp search-replace "https://$REMOTE_DOMAIN" "$URL" --recurse-objects --network --skip-columns=guid --skip-tables=wp_users

    wp plugin activate elementor
    wp elementor replace_urls "https://$REMOTE_DOMAIN" "$URL"
    wp plugin deactivate elementor
)

exit 0