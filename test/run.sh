#!/bin/sh
#
# Simple tests for git backup scripts.
#
# A git repository is cloned from a bundle file and filled with 10 dummy commits.
# after every change, a incremental bundle file is created in ./backups directory.
# Afterwards the repository is restored from the bundle files into /tmp/git/repoA.
#

TEST_BACKUP_DIR="backups"
TEST_BUNDLE="repo.bundle"
GBACKUP_DIR="../src"
REPO_NAME="repoA"
TMP_DIR="/tmp/git"
TMP_REPO="/tmp/git/${REPO_NAME}"

for i in `seq 1 10`
do
	./test-fill-repo.sh ${TEST_BUNDLE} ${TMP_REPO} ${GBACKUP_DIR} ${TEST_BACKUP_DIR}
	sleep 1
done

./test-restore-repo.sh ${REPO_NAME} ${GBACKUP_DIR} ${TEST_BACKUP_DIR}
rc=$?

if [ ${rc} -eq 0 ]; then
	echo "OK"
else
	echo "ERROR"
fi

rm -Rf ${TEST_BACKUP_DIR}
rm -Rf ${TMP_DIR}
 
