include apt

apt::key { 'cran':
  id      => 'E084DAB9',
  server  => 'keyserver.ubuntu.com',
} ->
apt::source { 'R':
  comment  => 'This is the apt repository for R - the language for statistical computing',
  location => 'http://cran.rstudio.com/bin/linux/ubuntu/',
  release  => 'trusty/',
  repos    => '',
} ->
exec { 'apt-update':
  command => '/usr/bin/apt-get update',
} ->
package { "littler":
  ensure  => latest,
} ->
user { 'vagrant':
  groups => ["vagrant", "staff"]
} ->
class { 'r':
  require => Apt::Source['R'],
} ->
r::package { 'dplyr':
  dependencies => true,
} ->
package { 'libmysqlclient-dev':
  ensure => latest,
} ->
r::package { 'RMySQL':
  dependencies => true,
} ->
r::package { 'forecast':
  dependencies => true,
} ->
package { 'libcurl4-gnutls-dev':
  ensure => latest,
} ->
package { 'libcurl4-openssl-dev':
  ensure => latest,
} ->
package { 'libxml2-dev':
  ensure => latest,
} ->
r::package { 'devtools':
  r_path => "/usr/bin/r",
  dependencies => true,
} ->
exec { "install_RDruid":
  command => "/usr/bin/r -e \"devtools::install_github(\\\"metamx/RDruid\\\")\"",
  creates => "/usr/local/lib/R/site-library/RDruid",
}