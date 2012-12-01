import "server"

node precise32 inherits server {

  # Main site
  nginx::resource::vhost { 'hceris.com':
    ensure   => present,
    www_root => '/srv/www/main/',
    index_files => ['index.html'],
  }

  file { '/srv/www/main':
    ensure => 'directory',
    owner => 'sirech',
    before => Nginx::Resource::Vhost['hceris.com'],
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
    before => Nginx::Resource::Vhost['images.hceris.com'],
  }

  file { '/srv/www':
    ensure => 'directory',
  }

  user { 'sirech':
    groups => ['adm', 'sudo'],
    ensure => 'present',
  }

  User['sirech'] -> File['/srv/www'] -> File['/srv/www/main']
}
