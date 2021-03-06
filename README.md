git-backup
==========
Simple shell scripts for creating and restoring incremental backups of git repositories using git bundles.

The backup routine uses git `bundle create --all last_backup_tag..master` to create incremental bundles.
After restoring the backup only the `master` branch will be restored.

Backup
----------
Create a backup of a single repository and save it into `/backup`:
```
backup-git.sh /path/to/repository /backup
```

Create backups of multiple repositories located in `~/projects` and save them into `/backup`:
```
backup-git.sh ~/projects /backup
```

Restore
----------
In order to restore a repository named `repository` into `/tmp/git/repository`,
run the restore script from the directory containing `repository_*.bundle` files:

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

