include apt

apt::key { 'cran':
  id      => 'E084DAB9',
  server  => 'keyserver.ubuntu.com',
}

apt::source { 'R':
  comment  => 'This is the apt repository for R - the language for statistical computing',
  location => 'http://cran.rstudio.com/bin/linux/ubuntu/',
  release  => 'trusty/',
  repos    => '',
}

exec { 'apt-update':
  command => '/usr/bin/apt-get update',
}

user { 'vagrant':
  groups => ["vagrant", "staff"]
}

package { 'libmysqlclient-dev':
  ensure => latest,
}

class { 'r': 
  require => Apt::Source['R'],
}

package { 'libcurl4-gnutls-dev':
  ensure => latest,
}

package { 'libcurl4-openssl-dev':
  ensure => latest,
}

package { 'libxml2-dev':
  ensure => latest,
}

r::package { 'devtools': 
  dependencies => true,
}

package { "littler":
  ensure  => latest,
}

exec { "install_RDruid":
  command => "/usr/bin/r -e \"devtools::install_github(\\\"metamx/RDruid\\\")\"",
  require => Package['littler'],
}

r::package { 'forecast': 
  dependencies => true,
}

r::package { 'dplyr': 
  dependencies => true,
}

r::package { 'RMySQL': 
  dependencies => true,
}
