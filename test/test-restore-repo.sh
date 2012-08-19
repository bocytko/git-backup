#!/bin/sh
#
# Restores a git repository from bundle files
# using backup-git-restore.sh.
# The restored repository is saved in /tmp/git/
#

REPO=${1:-"repoA"}

GBACKUP_DIR=${2:-"../src"}
BACKUP_DIR=${3:-"backups"}

RESTORE_DIR="/tmp/git"

GBACKUP_DIR=`readlink -f ${GBACKUP_DIR}`
BACKUP_DIR=`readlink -f ${BACKUP_DIR}`

if [ ! -f ${GBACKUP_DIR}/backup-git-restore.sh ]; then
	echo "ERROR: ${GBACKUP_DIR}/backup-git-restore.sh does not exist!"
	exit 1
fi

if [ ! -d ${BACKUP_DIR} ]; then
	echo "ERROR: ${BACKUP_DIR} does not exist!"
	exit 1
fi

oldDir=`pwd`

cd ${BACKUP_DIR} 

${GBACKUP_DIR}/backup-git-restore.sh ${RESTORE_DIR} ${REPO}
rc=$?

if [ ${rc} != 0 ]; then
	echo "ERROR"
else
	echo "OK"
fi

cd ${oldDir}

