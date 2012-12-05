import "base"

node server inherits basenode {

  package { 'build-essential':
    ensure => present,
  }

  include ntp

  class { 'nodejs':
    dev_package => true
  }

  include nginx

  class { 'python':
    version => '2.7',
    dev => true,
    virtualenv => true,
  }

  # Main site
  nginx::resource::vhost { 'hceris.com':
    ensure   => present,
    www_root => '/srv/www/main/',
    index_files => ['index.html'],
  }

  file { '/srv/www/main':
    ensure => 'directory',
    owner => 'sirech',
  }

  # images
  nginx::resource::vhost { 'images.hceris.com':
    ensure   => present,
    www_root => '/srv/www/images/',
    index_files => [],
  }

  file { '/srv/www/images':
    ensure => 'directory',
    owner => 'sirech',
  }

  file { '/srv/www':
    ensure => 'directory',
    owner => 'sirech'
  }

  user { 'sirech':
    ensure => 'present',
    groups => ['adm', 'sudo'],
    managehome => true,
  }

  User['sirech'] -> File['/srv/www'] -> File['/srv/www/main'] -> File['/srv/www/images']

  # Auto complete NodeJS app
  class { 'auto-complete':
  }

  # shell
  class { 'shell':
  }

  # MoinMoin wiki
  class { 'moin':
  }

  # Deliver mailing list
  class { 'deliver':
  }
}
