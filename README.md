# Dotfiles repo

This is totally under construction, an ongoing work in progress. But, since I like to share this with those newer to the command line,
here is a listing of what each script is for, more or less.

Need to re-do this with [YADM](https://yadm.io/#)

To initialize a new machine, try `init.sh`.

## Contents

- [./bash_aliases.sh](./bash_aliases.sh) is a bunch of bash aliases.
- [./bash_customizations.sh](./bash_customizations.sh) is mostly for command line prompt customization.
- [./disable_bell.sh](./disable_bell.sh) is to get rid of that ding when tab complete fails among other things.
- [./get_fzf.sh](./get_fzf.sh) will install [the best command-line fuzzy finder](https://github.com/junegunn/fzf) (will replace the default `ctrl-i` function and is used by other common utilities.)
- [./get_hadolint.sh](./get_hadolint.sh) installs [Hadolint](https://github.com/hadolint/hadolint) which is a Dockerfile linter that bundles in shellcheck (see below) for shell scripts which are inlined in dockerfiles.
- [./get_shellcheck.sh](./get_shellcheck.sh) installs [shellcheck](https://github.com/koalaman/shellcheck) a shell script static analyzer - super helpful.
- [./init.sh](./init.sh) will notionally configure a blank system just the way I like it - may not be up-to-date.
- [./install_ansible.sh](./install_ansible.sh) installs [Ansible](https://www.ansible.com/) an [Infrastructure as Code](https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code) _**Server** Provisioning and Setup_ tool. This is not an all purpose, suitable for every-use-case DevOps tool, but, it has it's use-cases and is frequently encountered in the DoD even if it is used for things other tools are better at.
- [./install_docker.sh](./install_docker.sh) This installs, [Docker](https://www.docker.com/) the common frontend tool for creating [OCI complient images](https://opencontainers.org/). Sort of the kleenex of tissues if that makes sense. This particular script is meant for WSL2 based installs where there are a few quirks.
- [./install_duo.sh](./install_duo.sh) Installs the Duo 2FA client specifically for use where git ssh connections are proxied through it to get to protected git repos.
- [./install_go.sh](./install_go.sh) installs [GoLang](https://go.dev/), my preferred language for anything in the DevOps space and also a leading backend language.
- [./install_helm.sh](./install_helm.sh) installs [Helm](https://helm.sh/) the package manager for Kubernetes. Only needed for cloud dev.
- [./install_k9s.sh](./install_k9s.sh) installs [K9s](https://github.com/derailed/k9s) a Kubernetes CLI - it's awesome.
- [./install_kind.sh](./install_kind.sh) installs [Kind](https://github.com/kubernetes-sigs/kind) which is a way to run Kubernetes clusters locally in a docker image.
- [./install_kubectl.sh](./install_kubectl.sh) installs [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/), the Kubernetes command line tool.
- [./install_kubie.sh](./install_kubie.sh), [Kubie](https://github.com/sbstp/kubie) is a great way to manage multiple kubernetes cluster contexts and namespaces. The replacement for kubectx and kubens.
- [./install_standard_packages.sh](./install_standard_packages.sh) just brings in all my expected utilities that don't come standard like `tree`.
- [./modify_bashrc.sh](./modify_bashrc.sh) your local ~/.bashrc file needs to pick up the bash_alias.sh and bash_customizations.sh files. This modifies it to do that.
- [./utilities.sh](./utilities.sh) this has held various versions of my attempt to abstract over the details of pulling the latests git release off GitHub for each of the aforementioned tools. Generally less succesful than hoped.

## Links to install programs

Meant to save time googling

- [Cubic custom ISO maker](https://itsubuntu.com/install-cubic-ubuntu-custom-ubuntu-iso-creator/)
- [Install Duo for git](https://git.aoc-pathfinder.cloud/kr/adcp/program-management/-/wikis/DuoConnect-for-Gitlab-SSH)
- [Install Docker](https://docs.docker.com/engine/install/ubuntu)
- [Install Scala's SBT](https://www.scala-sbt.org/1.x/docs/Installing-sbt-on-Linux.html)
- [Install Keybase](https://keybase.io/docs/the_app/install_linux)
- [Disable the bash bell](https://unix.stackexchange.com/questions/73672/how-to-turn-off-the-beep-only-in-bash-tab-complete)
