#!/bin/sh
#
# Backup one (or more) git repositories using bundle files.
#
# Searches for git repositories inside the given directory
# and creates incremental bundle files containing the changes since last backup.
# The tag "lastBackup" is used to mark the last commit that was included in a bundle.
#
# Usage: backup-git-restore.sh <repository_dir> <backup_dir>
# Creates bundle files for repositories found in <repository_dir> and saves them in <backup_dir>.
# Bundle filename pattern "<repository_name>_YYYYmmdd-HHMMSS.bundle"
#

BACKUP_REPOS_BASEDIR=${1:-"."}
BACKUP_DIR=${2:-"$HOME/backup"}

BACKUP_TAG="lastBackup"

find ${BACKUP_REPOS_BASEDIR} -maxdepth 2 -type d -name '.git' | while read repoDir
do
	dir=`dirname ${repoDir}`
	repoName=`basename ${dir}`

	echo "Processing ${repoName}..."

	datetime=`date +%Y%m%d-%H%M%S`
	fileName="${BACKUP_DIR}/${repoName}_${datetime}.bundle"

	oldDir=`pwd`

	cd ${repoDir}

	echo "INFO: checking tag '${BACKUP_TAG}'"
	if [ `git tag | grep -c ${BACKUP_TAG}` -eq 0 ]; then
		# no backup was ever made, create initial bundle
	        echo "INFO: exporting ${repoName} to ${fileName}"
	        git bundle create ${fileName} --all
	else
		# tag pointing to previous backup found

		# check for commits since last backup
		if [ `git log ${BACKUP_TAG}..master --oneline | wc -l` -eq 0 ]; then
			echo "INFO: no changes since last backup!"

			cd ${oldDir}
			continue
		fi

		# create incremental bundle containing changes since last backup
		echo "INFO: '${BACKUP_TAG}' tag:"
		git rev-parse ${BACKUP_TAG}^0 

		echo "INFO: exporting '${repoName}' (${BACKUP_TAG}..master) to ${fileName}"
		git bundle create ${fileName} --all ${BACKUP_TAG}..master
	fi

	echo "INFO: veryfing bundle '${fileName}'"
	git bundle verify ${fileName}

	echo "INFO: creating tag '${BACKUP_TAG}'"
	git tag -f ${BACKUP_TAG} master

	cd ${oldDir}
done

