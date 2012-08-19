#!/bin/sh
#
# Clones a git repository from repo.bundle file if it does not exist yet,
# simulates changes and creates an incremental backup bundle
# using backup-git.sh.
#

SRC_BUNDLE=${1:-"repo.bundle"}
REPO=${2:-"repoA"}
GBACKUP_DIR=${3:-"../src"}
BACKUP_DIR=${4:-"backups"}

GBACKUP_DIR=`readlink -f ${GBACKUP_DIR}`
BACKUP_DIR=`readlink -f ${BACKUP_DIR}`

if [ ! -f ${GBACKUP_DIR}/backup-git.sh ]; then
	echo "${GBACKUP_DIR}/backup-git.sh does not exist!"
	exit 1
fi

if [ ! -d ${BACKUP_DIR} ]; then
	mkdir ${BACKUP_DIR}
fi

# clone repository from bundle if it does not exist yet
if [ ! -d ${REPO} ]; then
	git clone ${SRC_BUNDLE} ${REPO}
fi

# switch to repository directory
oldDir=`pwd`
cd ${REPO}

# change files in repository
echo "AAA" >> A

# commit
datetime=`date +%Y%m%d-%H%M%S`
git commit -am "changes ${datetime}"

# return to original directory
cd ${oldDir}

# run backup
${GBACKUP_DIR}/backup-git.sh ${REPO} ${BACKUP_DIR} 

