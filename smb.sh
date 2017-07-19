
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
echo -e "\n$( date +'%Y-%m-%d %H:%M:%S.%N' ) Starting\n"

# only run on the first friday of the month
if [ $(date +"%m") -eq $(date -d 7days +"%m") ]; then
  echo -e "not first friday of the month, exiting\n"
  echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
  exit 1;
fi

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Loading configuration\n"
if [ -f .env ]; then
  source .env;
else
  echo -e ".env does not exist, please copy the .envTemplate and add your details\n"
  echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
  exit 1;
fi

SOURCE_FOLDER="${SOURCE_MOUNT_POINT}${SOURCE_PATH}"
BACKUP_FOLDER="${BACKUP_MOUNT_POINT}${BACKUP_PATH}"

echo -e "Paths:"
echo -e " * $SOURCE_FOLDER"
echo -e " * $BACKUP_FOLDER\n"

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Verifying mount points exist\n"
if [ ! -d $SOURCE_MOUNT_POINT ]; then
  echo -e "Source mount point does not exist, please run the setup, exiting\n"
  echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
  exit 1;
fi
if [ ! -d $BACKUP_MOUNT_POINT ]; then
  echo -e "Backup mount point does not exist, please run the setup, exiting\n"
  echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
  exit 1;
fi

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Mounting source share\n"
mount.cifs //$SOURCE_SERVER_IP/$SOURCE_SHARE_NAME -o username=$SOURCE_USERNAME,password=$SOURCE_PASSWORD,dom=$SOURCE_DOMAIN $SOURCE_MOUNT_POINT

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Mounting backup share\n"
mount.cifs //$BACKUP_SERVER_IP/$BACKUP_SHARE_NAME -o username=$BACKUP_USERNAME,password=$BACKUP_PASSWORD,dom=$BACKUP_DOMAIN $BACKUP_MOUNT_POINT

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Verifying mounts\n"
if [ ! -d $SOURCE_FOLDER ]; then
  echo -e "Source share not mounted, exiting\n"
  echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
  exit 1;
fi
if [ ! -d $BACKUP_FOLDER ]; then
  echo -e "Backup share not mounted, exiting\n"
  echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
  exit 1;
fi

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Syncing backup files\n"
rsync -ua --progress $SOURCE_FOLDER*.lsb $BACKUP_FOLDER

echo -e "\n\n$( date +'%Y-%m-%d %H:%M:%S.%N' ) Unmounting shares\n"
umount $SOURCE_MOUNT_POINT
umount $BACKUP_MOUNT_POINT

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
exit 0
