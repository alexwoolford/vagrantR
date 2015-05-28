# vagrantR

Pre-requisites:
- Puppet
- Virtualbox
- Vagrant w/ the ubuntu/trusty64 box

TODO:
- Fix issue where puppet installs the version of R from Ubuntu's repo rather than the latest version from CRAN.
- Get Puppet to install `littler` and some R packages (`forecast`, `RMySQL`, and `dplyr`)


To try this VM:

    git clone https://github.com/alexwoolford/vagrantR
    cd vagrantR
    vagrant up
    vagrant ssh
