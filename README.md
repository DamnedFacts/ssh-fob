# ssh-fob #


##### Keep your SSH private keys on a USB keychain; use a script to initialize a self-destructing ssh-agent instance. #####

There are circumstances in which having your SSH on your person may be handy (such as on a USB flash drive), but how can you ensure physical, and electronic security while doing so?

**ssh-fob** is a simple script that will setup a Bash shell environment with an environment initialized for use by an instance of `ssh-agent`. When initialized, this script will load your custom keys located in a _ssh_keys_ directory into this running SSH agent.

## Usage ##
### Setup ###
    $ Mount your USB drive, formatted as UDF (see below)
    $ cd to your USB drive.
    $ git clone https://github.com/DamnedFacts/ssh-fob.git
    $ cp <your ssh keys> <path to USB> ssh-fob/ssh_keys/

### Use ###
    $ ./fob_init.sh
    $ ssh <user>@<host>

A new bash shell is spawned with its environment set to use the launched `ssh-agent` instance. When you are finished, cleanly exit the shell. This allows `ssh-agent` to exit along with it, ensuring your key isn't accidentally left behind on a strange workstation.

## Security ##
Make sure **ALL** SSH private keys you place on a portable USB device are **encrypted with a strong passphrase**!

## USB Flash Drives ##
Flash drives are typically formatted as FAT32, or exFAT for compatability reasons; however there are shortcomings to this format. First, it is proprietary. Secondly, it has a 2GB file size limit. Thirdly, and most pertient to our situation, it does not support POSIX-style permissions.

You see, `ssh-agent` will not load any private key file looser than permission 600. You can't do this on a (ex)FAT formatted drive, at all so it's a nonstarter.

UDF to the rescue! The format is open, and more capable, including being able to assign permissions to files.

This [blog](http://tanguy.ortolo.eu/blog/article93/usb-udf) post explains it further.

TL;DR: For Mac users, this will suffice for formatting:

    $ sudo newfs_udf -m blk --wipefs yes -v <volume name> /dev/disk<num>
