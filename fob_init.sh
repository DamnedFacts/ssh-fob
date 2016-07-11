#!/bin/bash

# This will initialize a single shell with our ssh-agent and 
# load our private key. No other shell should load this key,
# i.e. this will not be something executable through ~/.bashrc


# Find the location of our init script. It should be in the 
# same directory as our '.sshenv' directory.
SELF=${BASH_SOURCE[0]}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ssh agent setup
SSH_AGENT_BIN=`which ssh-agent`
SSH_ADD_BIN=`which ssh-add`
SSH_FOB_KEYDIR="ssh_keys"
SSH_KEYS=`cd "${DIR}"; grep -rl 'BEGIN .* PRIVATE KEY' ${SSH_FOB_KEYDIR}`

function cleanup {
    [ -z ${SSH_AGENT_PID} ] && exit 0

    echo
    echo "Current ssh keys are loaded, cleaning up:"
    ${SSH_ADD_BIN} -l | awk '{ print $3 }'
    echo
    echo "Unloading keys from ssh-agent (${SSH_AGENT_PID})"
    ${SSH_ADD_BIN} -D
    echo
    
    sleep 1
}

function preinit_agent {
     export RC_EXECUTE=YES

     [ -z "${SSH_KEYS}" ] && echo "No ssh keys found, exiting." && exit 1
     [ -z "${SSH_AGENT_BIN}" ] && echo "No ssh-agent command found, exiting." && exit 1
     [ -z "${SSH_ADD_BIN}" ] && echo "No ssh-add command found, exiting." && exit 1

     echo "Initialising new SSH agent..."
     ${SSH_AGENT_BIN} bash --rcfile ${SELF} || exit 1
     echo finished!
}

function agent_init {
    echo "Adding SSH keys to keychain"
    ${SSH_ADD_BIN} ${SSH_KEYS}

    alias ssh="ssh -A"
    export PS1="\h:\W \u [ssh-agent]\$ "
}


# Source SSH settings, if applicable
if [ -z ${RC_EXECUTE} ]; then
    preinit_agent
elif [ -n ${RC_EXECUTE} ]; then
    trap cleanup EXIT QUIT
    agent_init
fi
