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

class { 'r': 
  require => Apt::Source['R'],
}

r::package { 'forecast': 
  dependencies => true
}

r::package { 'dplyr': 
  dependencies => true
}

r::package { 'RMySQL': 
  dependencies => true
}

package { "littler":
  ensure  => latest,
}