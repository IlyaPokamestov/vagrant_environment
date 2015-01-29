$db_name = "flat"

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class system-update {

  exec { 'apt-get update':
    command => 'apt-get update',
  }

  $sysPackages = [ "build-essential" ]
  package { $sysPackages:
    ensure => "installed",
    require => Exec['apt-get update'],
  }
}

class development {

  $devPackages = [ "curl", "git", "vim", "mc" ]
  package { $devPackages:
    ensure => "installed",
    require => Exec['apt-get update'],
  }
}

class nginx-setup {

  include nginx

  package { "python-software-properties":
    ensure => present,
  }

  file { '/etc/nginx/sites-available/flat':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/nginx/default',
    require => Package["nginx"],
  }

  file { "/etc/nginx/sites-enabled/flat":
    notify => Service["nginx"],
    ensure => link,
    target => "/etc/nginx/sites-available/flat",
    require => Package["nginx"],
  }
}

class mysql {
  # Installs the MySQL server and MySQL client
  package { ['mysql-server', 'mysql-client']:
    ensure => installed,
    require => Exec['apt-get update'],
  }

  # Ensures the Mysql service is running
  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'],
  }
}


class php-with-extensions {

  $php = ["php5-fpm", "php5-cli", "php5-gd", "php5-curl", "php5-mcrypt", "php5-xdebug", "php5-mysql", "php5-intl", "php5-tidy", "php5-imap"]

#  exec { 'add-apt-repository ppa:ondrej/php5':
#    command => '/usr/bin/add-apt-repository ppa:ondrej/php5',
#    require => Package["python-software-properties"],
#  }

  exec { 'apt-get update for latest php':
    command => '/usr/bin/apt-get update',
    before => Package[$php],
  }

  package { $php:
    notify => Service['php5-fpm'],
    ensure => latest,
  }

  package { "apache2.2-bin":
    notify => Service['nginx'],
    ensure => purged,
    require => Package[$php],
  }

  file { '/etc/php5/cli/php.ini':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/cli/php.ini',
    require => Package[$php],
  }

  file { '/etc/php5/fpm/php.ini':
    notify => Service["php5-fpm"],
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/fpm/php.ini',
    require => Package[$php],
  }

  file { '/etc/php5/fpm/php-fpm.conf':
    notify => Service["php5-fpm"],
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/fpm/php-fpm.conf',
    require => Package[$php],
  }

  file { '/etc/php5/fpm/pool.d/www.conf':
    notify => Service["php5-fpm"],
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/fpm/pool.d/www.conf',
    require => Package[$php],
  }

  service { "php5-fpm":
    ensure => running,
    require => Package["php5-fpm"],
  }

}


class composer {

  exec { 'install composer php dependency management':
    command => 'curl -s http://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer',
    require => [Package['php5-cli'], Package['curl']],
  }

}

class { 'apt':
  always_apt_update    => true
}

Exec["apt-get update"] -> Package <| |>

include system-update
include development
include nginx-setup
include mysql
include php-with-extensions
include composer

class { 'mysql::server':
  override_options => { 'root_password' => 'root', },
}

database{ "${db_name}":
  ensure  => present,
  charset => 'utf8',
  require => Class['mysql::server'],
}

database{ "${db_name}_dev":
  ensure  => present,
  charset => 'utf8',
  require => Class['mysql::server'],
}

database{ "${db_name}_test":
  ensure  => present,
  charset => 'utf8',
  require => Class['mysql::server'],
}