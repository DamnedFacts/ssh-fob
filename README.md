# ssh-fob #


##### Keep your SSH private keys on a USB keychain; use a script to initialize a self-destructing ssh-agent instance. #####

There are circumstances in which having your SSH on your person may be handy (such as on a USB flash drive), but how can you ensure physical and electronic security in doing so?

**ssh-fob** is a simple script that will setup a shell environment instantiated by ssh-agent. When initialized, it will load your custom keys located in a _ssh_keys_ directory.

## Usage ##
### Setup ###
    $ Mount your USB drive, formatted as UDF (see below)
    $ cd to your USB drive.
    $ git clone https://github.com/DamnedFacts/ssh-fob.git
    $ cp <your ssh keys> <path to USB> ssh-fob/ssh_keys/

### Use ###
    $ ./fob_init.sh
    $ ssh <user>@<host>

A new bash shell is spawned with its environment set to use the launched ssh-agent instance. When finished and the shell is exited, ssh-agent exits along with it, ensuring your key isn't accidentally left behind on a strange workstation.

## Security ##
Make sure **any** SSH key you place on a portable USB device is encrypted with a passphrase!


## USB Flash Drives ##
Flash drives are typically formatted as FAT32 or exFAT for compatability reasons; however there are shortcomings to this format. First, it is proprietary. Secondly, it has a 2GB file size limit. Thirdly, and most pertient to our situation, it does not support POSIX-style permissions.

You see, ssh-agent will not load any keyfile is anything short of permissions 600. You can't do this on a (ex)FAT formatted drive.

So, UDF to the rescue! The format is open and more capable, including being able to assign permissions to files.

This [blog](http://tanguy.ortolo.eu/blog/article93/usb-udf) post explains it further.

For Mac users, this will suffice for formatting:

    $ sudo newfs_udf -v <volume name> --wipefs yes /dev/disk<num>
