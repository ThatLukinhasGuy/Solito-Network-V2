#!/bin/bash

#Log the errors too an .log file with time and date.
LOG_FILE=/mnt/volume1/NetBackup/logs/$(date +"%Y_%m_%d_%I_%M_%p").log;
exec 1>$LOG_FILE 2>&1;

BASEFOLDER0="/srv/deamon-data"
BASEFOLDER1="/var/lib/pterodactly/volumes"

#ssh root@10.0.1.12 'rm -rf ${BASEFOLDER1}/d5667f3c-854a-4572-9389-975b34fb82d9/logs/*.log.gz #waterfall anarchy
#ssh root@10.0.1.12 'rm -rf ${BASEFOLDER1}/7c998380-5960-4a40-ac9c-3c4a04f60273/logs/*.log.gz' #anarchy
#ssh root@10.0.1.12 'rm -rf ${BASEFOLDER1}/c361023e-3611-46a6-84d0-ec226344b733/logs/*.log.gz #creative_anarchy
ssh root@10.0.1.10 'rm -rf ${BASEFOLDER0}/36294af6-72e0-4b5a-a70f-97bbed5886ce/logs/*.log.gz' #waterfall
ssh root@10.0.1.10 'rm -rf ${BASEFOLDER0}/8a6aaf89-5ec4-4fc1-a9eb-7b6527347531/logs/*.log.gz' #hub
ssh root@10.0.1.10 'rm -rf ${BASEFOLDER0}/e87e16d5-3823-4f7a-990f-b2630d2ab3ba/logs/*.log.gz' #hub fallback
ssh root@10.0.1.10 'rm -rf ${BASEFOLDER0}/70855261-6812-42dd-8239-0d1af3a8638b/logs/*.log.gz' #building
ssh root@10.0.1.10 'rm -rf ${BASEFOLDER0}/4729558f-8069-419d-a32c-c8c681f17a7d//logs/*.log.gz' #staff smp