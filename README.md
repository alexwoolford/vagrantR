# vagrantR

Installs R on an Vagrant/Puppet provisioned Ubuntu VM and installs some packages to connect to MySQL (`RMySQL`), wrangle data (`dplyr`), and do some timeseries analysis (`forecast`).

Pre-requisites:
- Puppet
- Virtualbox
- Vagrant w/ the ubuntu/trusty64 box

To try this VM:

    git clone https://github.com/alexwoolford/vagrantR
    cd vagrantR
    vagrant up
    vagrant ssh
