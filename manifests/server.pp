import "base"

node server inherits basenode {

  class { 'timezone':
    timezone => 'Europe/Berlin'
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

  class { ruby:
    version => '2.0.0-p247'
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

  include sirech

  Class['sirech'] -> File['/srv/www'] -> File['/srv/www/main'] -> File['/srv/www/images']

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
