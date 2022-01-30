#!/usr/bin/bash

#Log File & Paths
ROOT_PATH="/root/Solito-Network"
DATE=$(date +'%Y_%m_%d_%I_%M_%p_')
EXTENSION=".log"
LOG_FILE=/root/scripts/logs-github/${DATE}

#SRC/DEST dirs
SRCDIR_1="/srv/daemon-data/"
SRCDIR_2="/var/lib/pterodactyl/volumes/"


#Server DIRS
WATERFALL_ANARCHY_UUID=${SRCDIR_2}"d5667f3c-854a-4572-9389-975b34fb82d9"
ANARCHY_UUID=${SRCDIR_2}"7c998380-5960-4a40-ac9c-3c4a04f60273"
CREATIVE_ANARCHY_UUID=${SRCDIR_2}"c361023e-3611-46a6-84d0-ec226344b733"
WATERFALL_UUID=${SRCDIR_1}"36294af6-72e0-4b5a-a70f-97bbed5886ce"
HUB_UUID=${SRCDIR_1}"8a6aaf89-5ec4-4fc1-a9eb-7b6527347531"
HUB_FALLBACK_UUID=${SRCDIR_1}"e87e16d5-3823-4f7a-990f-b2630d2ab3ba"
SNAPSHOT_UUID=${SRCDIR_1}"04864553-742d-49ee-8e99-2a19f9d35d58"
DEVELOPMENT_UUID=${SRCDIR_1}"5f1f5a83-e920-4a78-95a8-4b20be19b250"
BUILDING_UUID=${SRCDIR_1}"70855261-6812-42dd-8239-0d1af3a8638b"
STAFF_SMP_UUID=${SRCDIR_1}"4729558f-8069-419d-a32c-c8c681f17a7d"
SKYBLOCK_UUID=${SRCDIR_1}"05464e89-388e-4dd1-bf64-7b893fc47a8d"
MINIGAMES_UUID=${SRCDIR_1}"0c5f24d5-0c34-4d84-9c97-333048ee1b69"
SURVIVAL_V3_UUID=${SRCDIR_1}"27b03e74-e0ee-48f3-ba36-162d7b58fd50"
SURVIVAL_V4_UUID=${SRCDIR_1}"98b1d421-bf8a-42ce-8aef-fa65ed2396ba"

#Include/Exlcude files
INCLUDE_GITHUB="/root/scripts/include-github.txt"
EXCLUDE_GITHUB="/root/scripts/exclude-github.txt"

cd ${ROOT_PATH}

exec 1>${LOG_FILE}"weekly"${EXTENSION} 2>&1

#Make sure source is updated
git checkout main
git pull

#Sync all servers
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/waterfall_anarchy/ root@10.0.1.12:${WATERFALL_ANARCHY_UUID}  #waterfall anarchy
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/anarchy/ root@10.0.1.12:${ANARCHY_UUID} #anarchy
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/creative_anarchy/ root@10.0.1.12:${CREATIVE_ANARCHY_UUID} #creative anarchy
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/waterfall/ ${WATERFALL_UUID} #waterfall
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/hub/ ${HUB_UUID} #hub
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/hub_fallback/ ${HUB_FALLBACK_UUID} #hub fallback
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/snapshot/ ${SNAPSHOT_UUID} #snapshot
rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/development/ ${DEVELOPMENT_UUID} #development
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/building/ ${BUILDING_UUID} #building
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/staff_smp/ ${STAFF_SMP_UUID} #staff smp
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/skyblock/ ${SKYBLOCK_UUID} #skyblock
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/minigames/ ${MINIGAMES_UUID} #minigames
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/survival_v3/ ${SURVIVAL_V3_UUID} #survival v3
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/servers/survival_v4/ ${SURVIVAL_V4_UUID} #survival v4

#Sync all scripts
#rsync -a --include-from=${INCLUDE_GITHUB} ${ROOT_PATH}/scripts/ubuntu-srv-01/ /root/scripts #ubuntu-srv-01
#rsync -a --exclude-from=${EXCLUDE_GITHUB} ${ROOT_PATH}/scripts/ubuntu-nas-01/ root@10.0.1.13:/mnt/volume1/NetBackup/scripts #ubuntu-nas-01