# Bash tools for Gitea API

Tools for automating work with [Gitea](https://gitea.com/).

## Syntax

### Creating repository

- [repo.create.sh](repo.create.sh)
  - `-x 'TOKEN'`  
    Gitea user token.
  - `-a 'https://gitea.com'`  
    Gitea API URL.
  - `-o 'OWNER'`  
    Organization name. This is not case sensitive.
  - `-r 'REPO_1;REPO_2;REPO_3'`  
    Repository name (array).
  - `-d 'DESCRIPTION'`  
    Repository description.
  - `-l 'mit'`  
    Open source license template. For example, "mit" or "mpl-2.0".
  - `-b 'main'`  
    Repository default branch.
  - `-i`  
    Repository auto-init.
  - `-p`  
    Whether repository is private.

### Deleting repository

- [repo.delete.sh](repo.delete.sh)
  - `-x 'TOKEN'`  
    Gitea user token.
  - `-a 'https://gitea.com'`  
    Gitea API URL.
  - `-o 'OWNER'`  
    Repository owner (organization).
  - `-r 'REPO_1;REPO_2;REPO_3'`  
    Repository name (array).

### Transferring repository

- [repo.transfer.sh](repo.transfer.sh)
  - `-x 'TOKEN'`  
    Gitea user token.
  - `-a 'https://gitea.com'`  
    Gitea API URL.
  - `-o 'OWNER_OLD'`  
    OLD repository owner (organization).
  - `-n 'OWNER_NEW'`  
    NEW repository owner (organization).
  - `-r 'REPO_1;REPO_2;REPO_3'`  
    Repository name (array).

### Updating repository

- [repo.update.sh](repo.update.sh)
  - `-x 'TOKEN'`  
    Gitea user token.
  - `-a 'https://gitea.com'`  
    Gitea API URL.
  - `-o 'OWNER'`  
    Organization name. This is not case sensitive.
  - `-r 'REPO_1;REPO_2;REPO_3'`  
    Repository name (array).
  - `-d 'DESCRIPTION'`  
    Repository description.
  - `-b 'main'`  
    Repository default branch.
  - `-p`  
    Whether repository is private.
