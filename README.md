git-backup
==========
Simple shell scripts for creating and restoring incremental backups of git repositories using git bundles.

Backup
----------
Create backup of a single repository and save it in `/backup`:
```
backup-git.sh repository /backup
```

Create backups of multiple repositories located in `~/projects` and save them in `/backup`:
```
backup-git.sh ~/projects /backup
```

Restore
----------
Restore a repository named `repository` into `/tmp/git/repository`:

```
backup-git-restore.sh /tmp/git repository
```

