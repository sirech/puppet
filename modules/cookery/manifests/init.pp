class cookery (
  $app = 'cookery',
  $user = 'sirech',
  $runner = 'cook',
  $port = 4023,
  $thin_user = 'thin',
  $thin_config = '/etc/thin.d',
  $thin_log = '/var/log/thin',
  $thin_run = '/var/run/thin') inherits cookery::settings {

    $directory = "/srv/www/${app}"

    user { $runner:
      ensure => 'present'
    }

    file { [$directory, "$directory/shared", "$directory/shared/config"]:
      ensure => 'directory',
      owner => $user,
      group => $runner,
      require => [File['/srv/www'], User[$user, $runner]]
    }

    nginx::vhost { 'cookery.hceris.com':
      template => 'cookery/cookery.erb',
      docroot => "$directory/current",
      port => $port
    }

    # DB
    postgresql::db { $db_name:
      user => $db_user,
      password => $db_password,
    }

    file { 'database.yml':
      ensure => 'present',
      path   => "$directory/shared/config/database.yml",
      content => template("cookery/database.yml.erb"),
      require => File["$directory/shared/config"]
    }

    # Thin
    package { 'thin':
      ensure => 'latest'
    }

    user { $thin_user:
      ensure => 'present',
    }

    file {[$thin_config, $thin_log]:
      ensure => 'directory',
      owner => $thin_user,
      group => $thin_user
    }

    file { $thin_run:
      ensure => 'directory',
      mode => '1777',
      owner => $runner,
      group => $runner
    }

    file { 'thin-start':
      ensure => 'present',
      path   => "/etc/init/thin.conf",
      content => template("cookery/thin.conf.erb")
    }

    file { 'thin-start-link':
      ensure => symlink,
      path   => "/etc/init.d/thin",
      target => '/lib/init/upstart-job',
    }

    service { 'thin':
      ensure => 'running',
      hasrestart => true,
      require => [Package['thin'], User[$thin_user], File[$thin_config, $thin_log, $thin_run, 'thin-start', 'thin-start-link']]
    }

    file { "${thin_config}/${app}.yml":
      ensure => 'present',
      owner => $thin_user,
      group => $thin_user,
      content => template('cookery/thin-app.yml.erb'),
      notify => Service['thin'],
      require => File[$thin_config]
    }
  }
