# Terraform Beginner Bootcamp 2023

## Semantic Versioning 🦄

Given a version number **MAJOR.MINOR.PATCH** (e.g. `1.0.1`), increment the:

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

More information [here](https://semver.org/).

## Installing Terraform CLI

Updating the gitpod.yml installation script to install the latest version of Terraform CLI.
Instructions [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### New installation script (Bash file)

- check your [Linux distrubution](https://linuxize.com/post/how-to-check-linux-version/): `cat /etc/os-release`
- add [shebang](https://linuxize.com/post/bash-shebang/) to the script file: `#!/usr/bin/env bash`
- more on [Linux permissions](https://www.redhat.com/sysadmin/linux-file-permissions-explained):
  `chmod u+x <script_name>`
- use `before` instead of `init` hook, check [GitPod tasks](https://www.gitpod.io/docs/configure/workspaces/tasks), in short, `init` will not re-run if we restart an existing workspace, `before` will.

The new file is located here: [./bin/install-terraform.sh](./bin/install-terraform.sh)
