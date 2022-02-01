#!/usr/bin/bash

#Log File & Paths
ROOT_PATH="/root/scripts"
DATE=$(date +'%Y_%m_%d_%I_%M_%p_')
EXTENSION=".log"
LOG_FILE=${ROOT_PATH}/logs-github/${DATE}

#SRC/DEST dirs
DESTDIR="/root/Solito-Network"
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


#Msg for github
MSG_GIT="Updated Upstream (servers/scripts)"

#Sync all servers
exec 1>${LOG_FILE}"github-upstream"${EXTENSION} 2>&1

cd ${DESTDIR}

git pull

rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded -e ssh root@10.0.1.11:${WATERFALL_ANARCHY_UUID}/* ${DESTDIR}/servers/waterfall_anarchy/ #waterfall anarchy
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded -e ssh root@10.0.1.11:${ANARCHY_UUID}/* ${DESTDIR}/servers/anarchy/ #anarchy
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded -e ssh root@10.0.1.11:${CREATIVE_ANARCHY_UUID}/* ${DESTDIR}/servers/creative_anarchy/ #creative anarchy
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${WATERFALL_UUID}/* ${DESTDIR}/servers/waterfall/ #waterfall
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${HUB_UUID}/* ${DESTDIR}/servers/hub/ #hub
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${HUB_FALLBACK_UUID}/* ${DESTDIR}/servers/hub_fallback/ #hub fallback
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${SNAPSHOT_UUID}/* ${DESTDIR}/servers/snapshot/ #snapshot
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${DEVELOPMENT_UUID}/* ${DESTDIR}/servers/development/ #development
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${BUILDING_UUID}/* ${DESTDIR}/servers/building/ #building
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${STAFF_SMP_UUID}/* ${DESTDIR}/servers/staff_smp/ #staff smp
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${SKYBLOCK_UUID}/* ${DESTDIR}/servers/skyblock/ #skyblock
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${MINIGAMES_UUID}/* ${DESTDIR}/servers/minigames/ #minigames
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${SURVIVAL_V3_UUID}/* ${DESTDIR}/servers/survival_v3/ #survival v3
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded ${SURVIVAL_V4_UUID}/* ${DESTDIR}/servers/survival_v4/ #survival v4

#Sync all scripts
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded /root/scripts/* ${DESTDIR}/scripts/ubuntu-srv-01/ #ubuntu-srv-01
rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded -e ssh root@10.0.1.13:/mnt/volume1/NetBackup/scripts/* ${DESTDIR}/scripts/ubuntu-nas-01/ #ubuntu-nas-01

#Delete empty dirs
find ${DESTDIR}/servers/*/ -type d -empty -delete

#Add the files to github and upstream them with a commit
git add -A
git commit -m "${MSG_GIT}"
git push
