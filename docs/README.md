## How to work with this repo
---

1. Preparation

1.1. Change the current directory to the git repo root directory

1.2. Ensure the files in the `scripts` directory are executable

```
$ chmod -R 0755 ./scripts
```

1.3. Ensure that there is a symlink between the git pre-commit hook and the pre-commit script

```
$ ln -s ../../scripts/git-pre-commit.sh .git/hooks/pre-commit
```

1.4. If you need to create/update a Helm chart, either switch to `master` or create your own branch from `master`

```
$ git checkout master
$ git checkout -b <your branch>
```

2. Create/update a Helm chart and push your changes

```
$ git add .
$ git status
$ git commit -m '<your commit message>'
$ git push origin <your branch>
```

3. The pre-commit hook script will validate your Helm charts. If there are changes in the `charts` directory, Helm will try to generate `.tgz` packages for your charts. The `*.tgz`, `index.yaml` and `index.html` files will not be pushed to your branch, you wil need to switch to the `gh-pages` branch and push those files to it.

```
$ git add .
$ git status
$ git commit -m 'Release aws-irsa ver. 0.0.1'
$ git push origin gh-pages
$ git tag -a aws-irsa-0.0.1 f65714e1c32da67d7e0b21effbbf56297b3c2c41 -m 'Release aws-irsa ver. 0.0.1'
```

4. Verify your tag and push it

```
$ git tag -n
aws-irsa-0.0.1  Release aws-irsa ver. 0.0.1

$ git push --tags
```
