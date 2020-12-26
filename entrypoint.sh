#!/bin/sh

# setup dropbox uploader config file
echo "CONFIGFILE_VERSION=2.0" > ~/.dropbox_uploader
echo "OAUTH_APP_KEY=${DROPBOX_APP_KEY}" >> ~/.dropbox_uploader
echo "OAUTH_APP_SECRET=${DROPBOX_APP_SECRET}" >> ~/.dropbox_uploader
echo "OAUTH_REFRESH_TOKEN=${DROPBOX_REFRESH_TOKEN}" >> ~/.dropbox_uploader

# run backup once on container start to ensure it works
/backup.sh

# start crond in foreground
exec crond -f