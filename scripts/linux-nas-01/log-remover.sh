#!/usr/bin/bash

#Log File & Paths
ROOT_PATH=$(git root)
HOSTNAME=$HOSTNAME
DATE=$(date +'%Y_%m_%d_%I_%M_%p_')
EXTENSION=".log"
LOG_FILE=${ROOT_PATH}/scripts/${HOSTNAME}/logs-github/${DATE}

#SRC/DEST dirs
SRCDIR_1="/srv/daemon-data" #legacy
SRCDIR_2="/var/lib/pterodactyl/volumes"

#Server SRC DIRS
PROXY_ANARCHY_UUID="${SRCDIR_2}/38041d33-5b50-4dde-962e-95709f1d73be"
HUB_ANARCHY_UUID="${SRCDIR_2}/73056572-85e8-4979-b304-f6c247d0a599"
ANARCHY_UUID="${SRCDIR_2}/b095d9ae-9446-4019-af77-fa93ccd746d6"
CREATIVE_ANARCHY_UUID="${SRCDIR_2}/7e094680-db9b-4355-a294-f5644ae6e7eb"
CRAZY_ANARCHY_UUID="${SRCDIR_2}/49974344-b65f-48cb-9b18-4ee9cbdcb180"
PROXY_UUID="${SRCDIR_2}/3b371702-92ae-42a9-9f62-feb7410d9a6f"
HUB_UUID="${SRCDIR_2}/60ebe599-b5fb-448d-8cf8-645200107119"
SNAPSHOT_UUID="${SRCDIR_2}/a2c86a96-5b1c-41c3-a645-8a698c97a906"
DEVELOPMENT_UUID="${SRCDIR_2}/6d17e2a1-a4be-4704-824a-e2aa14cadf8b"
BUILDING_UUID="${SRCDIR_2}/a3273974-c645-4dd8-a5f1-abddfe8dea1d"
SURVIVAL_V5_UUID="${SRCDIR_2}/98b1d421-bf8a-42ce-8aef-fa65ed2396ba"

IP_NODE_0="10.0.1.10"
IP_NODE_1="10.0.1.11"

USER="root"

#IMPORTANT: ORDER MATTERS!!
SRV_SRC_LIST=( "${PROXY_ANARCHY_UUID}" )
SRV_IP_LIST=( "${IP_NODE_1}" )

exec 1>${LOG_FILE}"log-remover"${EXTENSION} 2>&1

for (( i=0; i<${#SRV_IP_LIST[@]}; i++ ));
do 
    ssh ${USER}@${SRV_IP_LIST[$i]} "rm -rf ${PROXY_ANARCHY_UUID[$i]}/logs/*.log.gz"; 
done