import "server"

node precise32 inherits server {

  # nginx::resource::vhost { 'hceris.com':
  #   ensure   => present,
  #   www_root => '/srv/www/main/',
  #   index_files => ['index.html'],
  #   try_files => ['$uri', '=404'],
  # }

  file { '/srv/www/main':
    ensure => 'directory',
    owner => 'sirech',
    # before => Nginx::Resource::Vhost['hceris.com'],
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
