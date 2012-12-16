git-backup
==========
Simple shell scripts for creating and restoring incremental backups of git repositories using git bundles.

Backup
----------
Create backup of a single repository and save it in `/backup`:
```
backup-git.sh /path/to/repository /backup
```

Create backups of multiple repositories located in `~/projects` and save them in `/backup`:
```
backup-git.sh ~/projects /backup
```

Restore
----------
Restore a repository named `repository` into `/tmp/git/repository`.
The script shall be run in the directory containing `repository_*.bundle` files:

```
backup-git-restore.sh /tmp/git repository
```

Testing
----------
The simplified test suite clones a repository from a bundle file, 
simulates a few commits and runs the backup after every single commit.

Afterwards the repository is restored from multiple bundle files.

```
cd test
./run.sh
```
