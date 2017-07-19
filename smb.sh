
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
echo -e "\n$( date +'%Y-%m-%d %H:%M:%S.%N' ) Starting\n"

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Loading configuration\n"
if [ -f .env ]; then
  source .env;
else
  echo -e ".env does not exist, please copy the .envTemplate and add your details\n"
  exit 1;
fi

SOURCE_FOLDER="${SOURCE_MOUNT_POINT}${SOURCE_PATH}"
BACKUP_FOLDER="${BACKUP_MOUNT_POINT}${BACKUP_PATH}"

echo -e "Paths:"
echo -e " * $SOURCE_FOLDER"
echo -e " * $BACKUP_FOLDER\n"

exit 1;

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Verifying mount points exist\n"
if [ ! -d $SOURCE_FOLDER ]; then
  echo -e "Source mount point does not exist, please run the setup, exiting\n"
  exit 1;
fi
if [ ! -d $BACKUP_FOLDER ]; then
  echo -e "Backup mount point does not exist, please run the setup, exiting\n"
  exit 1;
fi

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Mounting source share\n"
mount.cifs //$SOURCE_SERVER_IP/$SOURCE_SHARE_NAME -o username=$SOURCE_USERNAME,password=$SOURCE_PASSWORD,dom=$SOURCE_DOMAIN $SOURCE_MOUNT_POINT

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Mounting backup share\n"
mount.cifs //$BACKUP_SERVER_IP/$BACKUP_SHARE_NAME -o username=$BACKUP_USERNAME,password=$BACKUP_PASSWORD,dom=$BACKUP_DOMAIN $BACKUP_MOUNT_POINT

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Verifying mounts\n"
if [ ! -d $SOURCE_FOLDER ]; then
  echo -e "Source share not mounted, exiting\n"
  exit 1;
fi
if [ ! -d $BACKUP_FOLDER ]; then
  echo -e "Backup share not mounted, exiting\n"
  exit 1;
fi

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Syncing backup files\n"
rsync -ua --progress $SOURCE_FOLDER*.lsb $BACKUP_FOLDER

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Unmounting shares\n"
umount /mnt/lightspeed/
umount /mnt/tech/

echo -e "$( date +'%Y-%m-%d %H:%M:%S.%N' ) Done\n"
exit 0
