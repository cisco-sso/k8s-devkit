## Custom: Everything below this line is auto-edited by vagrant setup.sh scripts

silent() {
    "$@" 2>&1 > /dev/null
}

# emacs
export EDITOR=emacs

# for golang
export GOPATH=/go
export PATH=./bin:./bin/linux_amd64/:./vendor/bin:$GOPATH/bin:/usr/local/go/bin:$PATH

# for protocol buffers
export PATH=$PATH:/usr/local/protoc/bin

# for terraform
export PATH=$PATH:/usr/local/terraform/bin

# for gcloud, kubectl
export PATH=$PATH:/usr/local/google-cloud-sdk/bin
export KUBECONFIG=$(find ~/.kube/config* | tr '\n' ':')

# for direnv; only if interactive shell and direnv is installed
if [[ -n ${PS1:-''} ]] && silent which direnv; then
    eval "$(direnv hook bash)"
fi

# for hub alias; only if interactive shell and hub is installed
if [[ -n ${PS1:-''} ]] && silent which hub; then
    eval "$(hub alias -s)"
fi

#####################################################################
# Enable re-attaching screen sessions with ssh-agent support
#   If this is an interactive session that is also an ssh session
if [[ -n ${PS1:-''} && -n ${SSH_TTY:-''} ]] ; then
    # if there is an SSH_AUTH_SOCK set, and it is a socket, and it is not a link
    if [[ -n ${SSH_AUTH_SOCK:-''} && -S "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
        # then create the link
        rm -f ~/.ssh/ssh_auth_sock
        ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
        export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    fi
fi
#####################################################################

# for NVM (node version manager)
export NVM_DIR="$HOME/.nvm"
if [ -d $NVM_DIR ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# for GOVC (vmware vcenter cli client)
if [ -f ~/.govc/config ]; then
   source ~/.govc/config
fi

# For git commits from Cisco
if [ -f ~/Dev/.cisco.sh ]; then
   source ~/Dev/.cisco.sh
fi
