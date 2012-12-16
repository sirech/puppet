## Puppet Configuration

### Pre-Check

Don't forget to pull submodules with

    git submodule update

### Testing with a VM

The easiest way is to use _VirtualBox_. Here are the steps required to
get a _VM_ running:

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

* Install _vagrant_

    gem install vagrant

* Prepare _VM_

    vagrant up
    
* Connect to the _VM_

    vagrant ssh

### Annoying stuff

* Sometimes you have to manually call `sudo apt-get update` on the
remote server before some packages work again

### Deploying to a new server

* Log as _root_ to the server.

* Install _git_ and _puppet_:

    apt-get update && apt-get install git puppet
    
* Set the hostname:

    echo "$hostname" > /etc/hostname
    hostname -F /etc/hostname
    
* Edit `/etc/hosts` and add the hostname there too.

* Clone this repository:

    git clone git://github.com/sirech/puppet --recursive
    
* Copy the secret configuration files. If the structure is the same,
  just do this:
  
    scp -r {sirech,shell,moin,deliver} root@$hostname:/root/puppet/modules

* Run puppet:

    puppet apply manifests/site-${hostname}.pp --modulepath modules
    
    

