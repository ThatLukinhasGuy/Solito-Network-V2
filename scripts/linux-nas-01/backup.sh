#!/usr/bin/bash

#Log the errors too an .log file with time and date.
LOG_FILE=/mnt/volume1/NetBackup/logs/$(date +"%Y_%m_%d_%I_%M_%p").log;
exec 1>$LOG_FILE 2>&1

cd /mnt/volume1/NetBackup

#This is the folder you would like to backup to.
DESTFOLDER0="/mnt/volume1/NetBackup/database-backups"
DESTFOLDER1="/mnt/volume1/NetBackup/backups/ubuntu-srv-01"
DESTFOLDER2="/mnt/volume1/NetBackup/backups/ubuntu-srv-02"
DESTFOLDER4="/mnt/volume1/NetBackup/backups/ubuntu-nas-01"
DESTFOLDER5="/mnt/volume1/NetBackup/backups/ubuntu-websrv-01"

#This is the folder you would like to backup from.
HOSTFOLDER0="/root/backups/databases"
HOSTFOLDER1="/root/backups"

EXCULDE="/mnt/volume1/NetBackup/scripts/excluded.txt"

echo "Starting backup"

#Send starting message (Development).
curl "https://admin.solitomc.nl/api/client/servers/5f1f5a83/command" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer PVg762METgAo5eaDn8XFHckbo36lY2rCx0YfBYqEqj4Ve0ev' \
  -X POST \
  -b 'pterodactyl_session'='eyJpdiI6InhIVXp5ZE43WlMxUU1NQ1pyNWRFa1E9PSIsInZhbHVlIjoiQTNpcE9JV3FlcmZ6Ym9vS0dBTmxXMGtST2xyTFJvVEM5NWVWbVFJSnV6S1dwcTVGWHBhZzdjMHpkN0RNdDVkQiIsIm1hYyI6IjAxYTI5NDY1OWMzNDJlZWU2OTc3ZDYxYzIyMzlhZTFiYWY1ZjgwMjAwZjY3MDU4ZDYwMzhjOTRmYjMzNDliN2YifQ%3D%3D' \
  -d '{"command": "say Backup Started"}'

#Make a database backup.
ssh root@10.0.1.10 "mysqldump --all-databases > ${HOSTFOLDER0}/$(date +"%Y_%m_%d_%I_%M_%p").sql"

#Make backups.
#rsync -aAXHv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /path/to/backup <-- We should update too this. #TODO
rsync -axzh --delete --delete-excluded --exclude-from=${EXCLUDE} -e ssh root@10.0.1.10:/ ${DESTFOLDER1}/incremental/ #ubuntu-srv-01
rsync -axzh --delete --delete-excluded --exclude-from=${EXCLUDE} -e ssh root@10.0.1.11:/ ${DESTFOLDER2}/incremental/; #ubuntu-srv-02
rsync -axzh --delete --delete-excluded --exclude-from=${EXCLUDE} -e ssh root@10.0.1.20:/ ${DESTFOLDER5}/incremental/ #ubuntu-websrv-01
rsync -axzh --delete --delete-excluded --exclude-from=${EXCLUDE} / ${DESTFOLDER4}/incremental/ #ubuntu-nas-01

#Copy files.
rsync -vre "ssh" root@10.0.1.10:${HOSTFOLDER0}/* ${DESTFOLDER0} #ubuntu-srv-01 --> #ubuntu-nas-01 (Databases)

#Remove files that aren't needed anymore.
ssh root@10.0.1.10 'rm -rf ${HOSTFOLDER0}/*.sql'

#Send finished message (Development)
curl "https://admin.solitomc.nl/api/client/servers/5f1f5a83/command" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer PVg762METgAo5eaDn8XFHckbo36lY2rCx0YfBYqEqj4Ve0ev' \
  -X POST \
  -b 'pterodactyl_session'='eyJpdiI6InhIVXp5ZE43WlMxUU1NQ1pyNWRFa1E9PSIsInZhbHVlIjoiQTNpcE9JV3FlcmZ6Ym9vS0dBTmxXMGtST2xyTFJvVEM5NWVWbVFJSnV6S1dwcTVGWHBhZzdjMHpkN0RNdDVkQiIsIm1hYyI6IjAxYTI5NDY1OWMzNDJlZWU2OTc3ZDYxYzIyMzlhZTFiYWY1ZjgwMjAwZjY3MDU4ZDYwMzhjOTRmYjMzNDliN2YifQ%3D%3D' \
  -d '{"command": "say Backup Finished"}'

echo "Finished backup"
