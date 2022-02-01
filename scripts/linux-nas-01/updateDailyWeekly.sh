#!/usr/bin/bash


# Usage:
# ./updateDailyWeekly.sh --daily -> Only daily backup
# ./updateDailyWeekly.sh --weekly -> Only weekly backup
# ./updateDailyWeekly.sh --daily --weekly -> Daily & Weekly backup


# ****************** Globals ********************

#Log File & Paths
ROOT_PATH="/mnt/volume1/NetBackup"
DATE=$(date +'%Y_%m_%d_%I_%M_%p_')
EXTENSION=".log"
LOG_FILE=${ROOT_PATH}/logs/${DATE} #/mnt/volume1/NetBackup/logs/2021_07_14_03_10_PM_

# Destination Folders
DESTDIR0=${ROOT_PATH}"/database-backups"
DESTDIR1=${ROOT_PATH}"/backups/linux-srv-01"
DESTDIR2=${ROOT_PATH}"/backups/linux-srv-02"
DESTDIR3=${ROOT_PATH}"/backups/linux-srv-03"
DESTDIR4=${ROOT_PATH}"/backups/linux-nas-01"
DESTDIR5=${ROOT_PATH}"/backups/linux-websrv-01"

#IP's
IP_SRV_01="10.0.1.10"
IP_SRV_02="10.0.1.11"
IP_NAS_01="10.0.1.13"
IP_WEBSRV_01="10.0.1.20"

DESTINATION_LIST="${DESTDIR1} ${DESTDIR2} ${DESTDIR4} ${DESTDIR5}"
IP_LIST="${IP_SRV_01} ${IP_SRV_02} ${IP_NAS_01} ${IP_WEBSRV_01}"

# Source Folders.
SRCDIR0="/root/backups/databases"
SRCDIR1="/root/backups" #Unused

# Curl arguments
URL="https://panel.compieter.nl/api/client/servers/5f1f5a83/command"
AUTHORIZATION="Authorization: Bearer TOKEN"
CONTENT_TYPE='Content-Type: application/json'
ACCEPT_PT='Accept: Application/vnd.pterodactyl.v1+json'
PTERODACTYL_SESSION='eyJpdiI6InhIVXp5ZE43WlMxUU1NQ1pyNWRFa1E9PSIsInZhbHVlIjoiQTNpcE9JV3FlcmZ6Ym9vS0dBTmxXMGtST2xyTFJvVEM5NWVWbVFJSnV6S1dwcTVGWHBhZzdjMHpkN0RNdDVkQiIsIm1hYyI6IjAxYTI5NDY1OWMzNDJlZWU2OTc3ZDYxYzIyMzlhZTFiYWY1ZjgwMjAwZjY3MDU4ZDYwMzhjOTRmYjMzNDliN2YifQ%3D%3D'
START_MESSAGE='{"command": "say Making backups/archives started!"}'
END_MESSAGE='{"command": "say Making backups/archives finished!"}'

# Exclude folders
BACKUP_EXCLUDE="/root/backups/*"
NETPLAN_EXCLUDE="/etc/netplan"
FSTAB_EXCLUDE="/etc/fstab"
MDADM_EXCLUDE="/etc/mdadm"
EXCLUDE_FILE="/mnt/volume1/NetBackup/scripts/excluded.txt"

# Admin
USER="root"
IP="10.0.1.10"

# ***********************************************

function weeklyUpdate {
    echo "*** Weekly Update ***"
	echo "*** Run time: $(date) @ $(hostname)"

    #Todo: Also output to console while logging for debbuging purposes.
	exec 1>${LOG_FILE}"weekly"${EXTENSION} 2>&1
    
	cd ${ROOT_PATH}

	echo "Cleaning up old archives and databases.."

	find ${ROOT_PATH}/backups/* -name "*.tar.gz" -type f ! -path "*/incremental/*" -mtime +30 -delete
	find ${ROOT_PATH}/database-backups/ -name "*.sql" -type f -mtime +30 -delete

    echo "Starting creation of the archives.."

	#Sent starting message (Development)
    curl "${URL}" -H "${ACCEPT_PT}" -H "${AUTHORIZATION}" -H "${CONTENT_TYPE}" -X POST -b "${PTERODACTYL_SESSION}" -d "${START_MESSAGE}"

    #In case something go's horribly wrong we dont wanna fill up/remove the wrong folder... 
    cd ${ROOT_PATH}/temp/

	#Archiving all servers
	for DESTINATION in ${DESTINATION_LIST}
	do
    	tar -cpzf ${DESTINATION}/${DATE}.tar.gz --exclude=${BACKUP_EXCLUDE} --exclude=${NETPLAN_EXCLUDE} --exclude=${FSTAB_EXCLUDE} --exclude=${MDADM_EXCLUDE} --one-file-system ${DESTINATION}/incremental
	done

	#Sent finished message(Development)
	curl "${URL}" -H "${ACCEPT_PT}" -H "${AUTHORIZATION}" -H "${CONTENT_TYPE}" -X POST -b "${PTERODACTYL_SESSION}" -d "${END_MESSAGE}"

	echo "Finished creation of archives (Weekly)"
}

function dailyUpdate {
	echo "*** Daily Update ***"
	echo "*** Run time: $(date) @ $(hostname)"

    #Todo: Also output to console while logging for debbuging purposes.
    exec 1>${LOG_FILE}"daily"${EXTENSION} 2>&1

	cd ${ROOT_PATH}

	echo "Start creating backup (Daily)"
	systemctl stop smbd.service

	#Sent starting message (Development)
    curl "${URL}" -H "${ACCEPT_PT}" -H "${AUTHORIZATION}" -H "${CONTENT_TYPE}" -X POST -b "${PTERODACTYL_SESSION}" -d "${START_MESSAGE}"

	#Make a database backup.
	echo "*** Dumping MySQL Database to ${SRCDIR0}/${DATE}.sql on ${USER}@${IP}..."
	ssh ${USER}@${IP} "mysqldump --all-databases > ${SRCDIR0}/${DATE}.sql"

    echo "*** Backing up to ${DESTDIR1}/incremental/ from ${USER}@${IP_SRV_01}..."
    rsync -axzhHAX --delete --delete-excluded --exclude-from=${EXCLUDE_FILE} -e ssh ${USER}@${IP_SRV_01}:/ ${DESTDIR1}/incremental/ #linux-srv-01 --> #linux-nas-01 (Root Backup)

	echo "*** Backing up to ${DESTDIR2}/incremental/ from ${USER}@${IP_SRV_02}..."
    rsync -axzhHAX --delete --delete-excluded --exclude-from=${EXCLUDE_FILE} -e ssh ${USER}@${IP_SRV_02}:/ ${DESTDIR2}/incremental/ #linux-srv-02 --> #linux-nas-01 (Root Backup)

	echo "*** Backing up to ${DESTDIR2}/incremental/var/lib/pterodactyl from ${USER}@${IP_SRV_02}..."
	rsync -axzhHAX --delete -e ssh ${USER}@${IP_SRV_02}:/mnt/raid10/pterodactly/* ${DESTDIR2}/incremental/var/lib/pterodactyl #linux-srv-02 --> #linux-nas-01 (Pterodactyl volume folder Backup)

	echo "*** Backing up to ${DESTDIR5}/incremental/ from ${USER}@${IP_WEBSRV_01}..."
    rsync -axzhHAX --delete --delete-excluded --exclude-from=${EXCLUDE_FILE} -e ssh ${USER}@${IP_WEBSRV_01}:/ ${DESTDIR5}/incremental/ #linux-websrv-01 --> #linux-nas-01 (Root Backup)

	echo "*** Backing up to ${DESTDIR4}/incremental/ from /..."
    rsync -axzhHAX --delete --delete-excluded --exclude-from=${EXCLUDE_FILE} / ${DESTDIR4}/incremental/ #linux-nas-01 --> #linux-nas-01 (Root Backup)

    echo "*** Moving dumped MySQL Databases to ${DESTDIR0} from ${USER}@${IP}..."
    rsync -r -e ssh ${USER}@${IP}:${SRCDIR0}/* ${DESTDIR0} #linux-srv-01 --> #linux-nas-01 (Databases Backup)

	#Remove files that aren't needed anymore.
	echo "*** Cleaning up..."
	ssh ${USER}@${IP} "rm -rf ${SRCDIR0}/*.sql"

    echo "*** Modifying permissions for backup share..."
	chmod -R 750 ${DESTDIR1}/incremental/srv/daemon-data #legacy
	chmod -R 750 ${DESTDIR2}/incremental/var/lib/pterodactyl

    echo "*** Finalizing..."
	systemctl start smbd.service

	#Sent finished message(Development)
	curl "${URL}" -H "${ACCEPT_PT}" -H "${AUTHORIZATION}" -H "${CONTENT_TYPE}" -X POST -b "${PTERODACTYL_SESSION}" -d "${END_MESSAGE}"

	echo "*** Done creating backup (Daily)"

}


# Argument parser function
function parseArgs {
	for arg in "${@}"
	do
		case $arg in
			-h|--help)
			    printHelp
			    exit 0
			    shift
			;;
			-d|--daily)
                dailyUpdate
			    shift
			;;
			-w|--weekly)
                weeklyUpdate
			    shift
			;;
			*)
			    echo "${arg} can not be parsed."
			;;
		esac
	done

    if [ -z "$*" ];then 
        echo "No arguments provided. Exiting."
        printHelp
        exit 1
    fi
}


# Help function in case unvalid parameters are given
function printHelp {
	echo -e "\nUsage ${0} [--PARAMETER_ARGUMENT]"
	echo -e "\t -h|--help) -> Print this help."
    echo -e "\t -d|--daily) -> Daily backup."
	echo -e "\t -w|--weekly) -> Weekly backup.\n"
}


# ************ Start of the script ******************

# Parse the arguments and everything will cascade
parseArgs $@
