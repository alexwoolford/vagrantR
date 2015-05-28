
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

exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

package { "r-base-core":
  ensure  => latest,
  require  => Exec['apt-update'],
}

package { "littler":
  ensure  => latest,
}


/*




#exec { "apt-update":
#    command => "r -e \"install.packages('forecast', repos='http://cran.rstudio.com')\""
#}

#r -e "install.packages('forecast', repos='http://cran.rstudio.com')"
#r -e "install.packages('RMySQL', repos='http://cran.rstudio.com')"
#r -e "install.packages('dplyr', repos='http://cran.rstudio.com')"
#r -e "install.packages('zoo', repos='http://cran.rstudio.com')"

*/