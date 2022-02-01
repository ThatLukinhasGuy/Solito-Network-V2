#!/usr/bin/python3

import datetime
import os
import requests

# *************************** Globals ***********************************

# Date
current_date        = datetime.date.today()
current_date        = current_date.strftime("%Y_%b_%d_%H_%M_%S") # Year_Month_Day_Hour_Minute_Seconds

# Paths
rootPath            = "/mnt/volume1/NetBackup/" 
logFile             = "/mnt/volume1/NetBackup/logs/" + current_date 

# Excludes
backupExclude       = "/root/backups/"
netplanExclude      = "/etc/netplan"
fstabExclude        = "/etc/fstab"
mdadmExclude        = "/etc/mdadm"

# Destination Folders
destinationFolder0  = rootPath + "database-backups"
destinationFolder1  = rootPath + "backups/ubuntu-srv-01"
#destinationFolder2= rootPath + "backups/ubuntu-srv-02"
destinationFolder3  = rootPath + "backups/ubuntu-srv-03"
destinationFolder4  = rootPath + "backups/ubuntu-nas-01"
destinationFolder5  = rootPath + "backups/ubuntu-websrv-01"

# Host folders
hostFolder0="/root/backups/databases"
hostFolder1="/root/backups"

# Curl args
url                 = "https://panel.compieter.nl/api/client/servers/5f1f5a83/command"
authorization       = "Authorization: Bearer TOKEN"
contentType         = "Content-Type: application/json"
acceptPt            = "Accept: Application/vnd.pterodactyl.v1+json"
startMessage        = "{ 'command': 'say Making archives started!' }"
finishMessage       = "{ 'command': 'say Making archives finished!' }"

#Archiving extensions
archiveExtension = ".tar.gz"

# ************************************************************************
#TODO: Find a better method to do the archives - now I can't test it.


def changeDir(path):
    os.chdir(path)
    print("Directory changed to %" %(path))


def dailyUpdate():

    changeDir(rootPath)
    print("Starting creation of archives (daily)")

    # Send starting message (Development).
    os.system("curl " + url + " -H " + authorization + " -H " + contentType + " -H " + acceptPt + " -X POST " + " -d " + startMessage)

    #Make a database backup.
    os.system("ssh root@10.0.1.10 'mysqldump --all-databases'" + " > " + hostFolder0 + os.sep + current_date + ".sql")

    #Make backups.
    #TODO: Here on daily backup, update with the new rsync command that we found 2 days ago.

    #Remove files that are not needed anymore
    os.system("ssh root@10.0.1.10 rm -rf " + hostFolder0 + os.sep + "*.sql")

    #Send finished message (Development).
    os.system("curl " + url + " -H " + authorization + " -H " + contentType + " -H " + acceptPt + " -X POST " + " -d " + finishMessage)
    print ("Finished creation of archives (daily)")


def weeklyUpdate():

    changeDir(rootPath)
    print("Starting creation of archives (weekly)")

    # Send starting message (Development).
    os.system("curl " + url + " -H " + authorization + " -H " + contentType + " -H " + acceptPt + " -X POST " + " -d " + startMessage)

    # Make archives of the incremental backup
    changeDir(rootPath + "temp")
    os.system("tar -cpzf " + destinationFolder1 + os.sep + current_date + archiveExtension + " --exclude=" + backupExclude + "--exclude=" + netplanExclude + "--exclude=" + fstabExclude + "--exclude=" + mdadmExclude + " --one-file-system" + destinationFolder1 + os.sep + "incremental")
    #os.system("tar -cpzf " + destinationFolder2 + os.sep + current_date + archiveExtension + " --exclude=" + backupExclude + "--exclude=" + netplan + "--exclude=" + fstabExclude + "--exclude=" + mdadmExclude + " --one-file-system" + destinationFolder2 + os.sep + "incremental")
    os.system("tar -cpzf " + destinationFolder3 + os.sep + current_date + archiveExtension + " --exclude=" + backupExclude + "--exclude=" + netplanExclude + "--exclude=" + fstabExclude + "--exclude=" + mdadmExclude + " --one-file-system" + destinationFolder3 + os.sep + "incremental")
    os.system("tar -cpzf " + destinationFolder4 + os.sep + current_date + archiveExtension + " --exclude=" + backupExclude + "--exclude=" + netplanExclude + "--exclude=" + fstabExclude + "--exclude=" + mdadmExclude + " --one-file-system" + destinationFolder4 + os.sep + "incremental")
    os.system("tar -cpzf " + destinationFolder5 + os.sep + current_date + archiveExtension + " --exclude=" + backupExclude + "--exclude=" + netplanExclude + "--exclude=" + fstabExclude + "--exclude=" + mdadmExclude + " --one-file-system" + destinationFolder5 + os.sep + "incremental")

    #Send finished message (Development).
    os.system("curl " + url + " -H " + authorization + " -H " + contentType + " -H " + acceptPt + " -X POST " + " -d " + finishMessage)
    print ("Finished creation of archives (weekly)")


def parseArguments():

    parser = argparse.ArgumentParser(description="Backup script for the server")
    parser.add_argument('-d', '--daily',
                        dest='dailyRoutine', help='Use this argument to do a daily backup.')
    parser.add_argument('-w', '--weekly',
                        dest='weeklyRoutine', help='Use this argument to do a weekly backup.')

    return parser.parse_args()


def main():

    arguments = parseArguments()
    if arguments.dailyRoutine == True:
        dailyUpdate()

    if arguments.weeklyRoutine == True:
        weeklyUpdate()

if __name__ == "main":
    main()
