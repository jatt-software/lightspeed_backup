#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
echo -e "\n$( date +'%Y-%m-%d %H:%M:%S.%N' ) Starting\n"

cd "$(dirname "$0")"

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Loading configuration\n"
if [ -f .env ]; then
  source .env;
else
  echo -e ".env does not exist, please copy the .envTemplate and add your details\n"
  echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
  exit 1;
fi

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) uploading $LOGPATH"
curl --progress-bar --output /dev/null -F 'logFile=@'$LOGPATH $UPLOAD_LOGS"?site="$SITE
echo -e "\n"

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
exit 0
