#!/usr/bin/bash

#Log the errors too an .log file with time and date.
LOG_FILE=/mnt/volume1/NetBackup/logs/$(date +"%Y_%m_%d_%I_%M_%p").log
exec 1>$LOG_FILE 2>&1

cd /mnt/volume1/NetBackup

#This is the folder you would like to backup to.
DESTFOLDER1="/mnt/volume1/NetBackup/backups/ubuntu-srv-01"
#DESTFOLDER2="/mnt/volume1/NetBackup/backups/ubuntu-srv-02"
DESTFOLDER3="/mnt/volume1/NetBackup/backups/ubuntu-srv-03"
DESTFOLDER4="/mnt/volume1/NetBackup/backups/ubuntu-nas-01"
DESTFOLDER5="/mnt/volume1/NetBackup/backups/ubuntu-websrv-01"

echo "Starting creation of archives (weekly)"

#Send starting message (Development).
curl "https://admin.solitomc.nl/api/client/servers/5f1f5a83/command" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer PVg762METgAo5eaDn8XFHckbo36lY2rCx0YfBYqEqj4Ve0ev' \
  -X POST \
  -b 'pterodactyl_session'='eyJpdiI6InhIVXp5ZE43WlMxUU1NQ1pyNWRFa1E9PSIsInZhbHVlIjoiQTNpcE9JV3FlcmZ6Ym9vS0dBTmxXMGtST2xyTFJvVEM5NWVWbVFJSnV6S1dwcTVGWHBhZzdjMHpkN0RNdDVkQiIsIm1hYyI6IjAxYTI5NDY1OWMzNDJlZWU2OTc3ZDYxYzIyMzlhZTFiYWY1ZjgwMjAwZjY3MDU4ZDYwMzhjOTRmYjMzNDliN2YifQ%3D%3D' \
  -d '{"command": "say Making archives started! (weekly)"}'


#Make archives of the incremental backup.
cd /mnt/volume1/NetBackup/temp
tar -cpzf ${DESTFOLDER1}/$(date +"%Y_%m_%d_%I_%M_%p").tar.gz --exclude="/root/backups/*" --exclude="/etc/netplan" --exclude="/etc/fstab" --exclude="/etc/mdadm" --one-file-system ${DESTFOLDER1}/incremental #Archive of ubuntu-srv-01
tar -cpzf ${DESTFOLDER2}/$(date +"%Y_%m_%d_%I_%M_%p").tar.gz --exclude="/root/backups/*" --exclude="/etc/netplan" --exclude="/etc/fstab" --exclude="/etc/mdadm" --one-file-system ${DESTFOLDER2}/incremental #Archive of ubuntu-srv-02
#tar -cpzf ${DESTFOLDER3}/$(date +"%Y_%m_%d_%I_%M_%p").tar.gz --exclude="/root/backups/*" --exclude="/etc/netplan" --exclude="/etc/fstab" --exclude="/etc/mdadm" --one-file-system ${DESTFOLDER3}/incremental #Archive of ubuntu-srv-03
tar -cpzf ${DESTFOLDER4}/$(date +"%Y_%m_%d_%I_%M_%p").tar.gz --exclude="/root/backups/*" --exclude="/etc/netplan" --exclude="/etc/fstab" --exclude="/etc/mdadm" --one-file-system ${DESTFOLDER4}/incremental #Archive of ubuntu-nas-01
tar -cpzf ${DESTFOLDER5}/$(date +"%Y_%m_%d_%I_%M_%p").tar.gz --exclude="/root/backups/*" --exclude="/etc/netplan" --exclude="/etc/fstab" --exclude="/etc/mdadm" --one-file-system ${DESTFOLDER5}/incremental #Archive of ubuntu-websrv-01

#Send finished message (Development).
curl "https://admin.solitomc.nl/api/client/servers/5f1f5a83/command" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer PVg762METgAo5eaDn8XFHckbo36lY2rCx0YfBYqEqj4Ve0ev' \
  -X POST \
  -b 'pterodactyl_session'='eyJpdiI6InhIVXp5ZE43WlMxUU1NQ1pyNWRFa1E9PSIsInZhbHVlIjoiQTNpcE9JV3FlcmZ6Ym9vS0dBTmxXMGtST2xyTFJvVEM5NWVWbVFJSnV6S1dwcTVGWHBhZzdjMHpkN0RNdDVkQiIsIm1hYyI6IjAxYTI5NDY1OWMzNDJlZWU2OTc3ZDYxYzIyMzlhZTFiYWY1ZjgwMjAwZjY3MDU4ZDYwMzhjOTRmYjMzNDliN2YifQ%3D%3D' \
  -d '{"command": "say Making archives finished! (weekly)"}'