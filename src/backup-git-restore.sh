#!/bin/sh
#
# Restore a single git repository from multiple bundle files.
#
# Run this script inside a directory with backup bundle files.
#
# Usage: backup-git-restore.sh <restore_dir> <repo_name>
# Restores the repository <repo_name> from bundle files named "<repo_name>_*.bundle"
# into a new git repository "<restore_dir>/<repo_name>".
#

RESTORE_DIR=$1
REPO=$2
REPO_DIR="$1/$2"

if [ $# -ne 2 ]; then
	echo "Usage: `basename $0` <restore_dir> <repo_name>"
	echo "Example: `basename $0` /tmp/git/ repo"
	exit 1
fi

rc=1

for file in `ls ${REPO}_*.bundle`
do
	backupDir=`pwd`

	bundleFile="${backupDir}/${file}"

	if [ -d ${REPO_DIR} ]; then
		# enter the repository if it exists
		cd ${REPO_DIR}

		# verify bundle against the repository
		echo "INFO: veryfing bundle '${file}' for '${REPO}'"
		git bundle verify ${bundleFile}
		rc=$?
		if [ ${rc} != 0 ]; then
			echo "ERROR: verification failed: ${rc}"
			exit ${rc}
		fi

		# pull changes from the bundle
		echo "INFO: pulling from bundle '${file}'..."
		git pull ${bundleFile}
		rc=$?
                if [ ${rc} != 0 ]; then
                        echo "ERROR: pull failed: ${rc}"
                        exit ${rc}
                fi
	else
		# no repository exists: first verify whether a repository may be created from the bundle
                echo "INFO: veryfing bundle '${file}' for '${REPO}'"
		git bundle verify ${bundleFile}
                rc=$?
                if [ ${rc} != 0 ]; then
                        echo "ERROR: verification failed: ${rc}"
                        exit ${rc}
                fi

		# create new repository using the first bundle file
		echo "INFO: restoring repo ${REPO} from bundle '${file}'..."
		git clone ${bundleFile} ${REPO_DIR}
                rc=$?
                if [ ${rc} != 0 ]; then
                        echo "ERROR: clone failed: ${rc}"
                        exit ${rc}
                fi
	fi

	cd ${backupDir}
done

if [ ${rc} -eq 0 ]; then
	echo "INFO: repository ${REPO} restored successfully"
else
	echo "ERROR: restoring failed: ${rc}"
	exit ${rc}
fi

