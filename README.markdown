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

    # The first two steps might be not necessary
    vagrant box add lucid32 http://files.vagrantup.com/lucid32.box
    vagrant init lucid32
    vagrant up
    
* Connect to the _VM_

    vagrant ssh
