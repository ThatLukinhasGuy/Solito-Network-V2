#!/bin/bash

#Log the errors too an .log file with time and date.
LOG_FILE=/mnt/volume1/NetBackup/logs/$(date +"%Y_%m_%d_%I_%M_%p").log;
exec 1>$LOG_FILE 2>&1;

BASEFOLDER0="/srv/deamon-data" #legacy
BASEFOLDER1="/var/lib/pterodactly/volumes"

#ssh root@10.0.1.12 'rm -rf ${BASEFOLDER1}/d5667f3c-854a-4572-9389-975b34fb82d9/logs/*.log.gz #waterfall anarchy