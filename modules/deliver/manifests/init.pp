class deliver (
  $user = 'sirech',
  $runner = 'deliver',
  $directory = '/srv/mail/deliver'
  ) inherits deliver::settings {

    $code = "$directory/deliver"
    $live = "$directory/live"
    $virtualenv = "$directory/pythonenv"

    # Startup scripts
    file { 'deliver-start':
      ensure => 'present',
      path   => "/etc/init/deliver.conf",
      content => template("deliver/deliver.conf.erb")
    }

    file { 'deliver-link':
      ensure => symlink,
      path   => "/etc/init.d/deliver",
      target => '/lib/init/upstart-job',
    }

    # Virtual env
    python::virtualenv { $virtualenv:
      ensure => present,
      version => $version,
    }

    # Directories
    user { $runner:
      ensure => 'present',
    }

    file { '/srv/mail':
      ensure => 'directory',
      owner => $user,
      group => $runner,
      require => User[$user, $runner]
    }

    file { $directory:
      ensure => 'directory',
      owner => $user,
      group => $runner,
      require => File['/srv/mail']
    }

    # Python packages

    package { 'libpq-dev':
      ensure => present,
    }

    python::pip { 'psycopg2':
      ensure => present,
      virtualenv => $virtualenv,
      require => [Python::Virtualenv[$virtualenv], Package['build-essential', 'libpq-dev']],
    }

    file { 'deliver-pythonenv-owner':
      path => $virtualenv,
      owner => $user,
      group => $runner,
      recurse => true,
      require => Python::Pip['psycopg2']
    }

    # Package

    exec {
      'git clone deliver':
        command => "git clone git://github.com/sirech/deliver.git",
        cwd => "$directory",
        creates => $code,
        user => $user,
        group => $runner,
        path => '/usr/bin',
        require => File[$directory];

      'setup.py deliver':
        command => "$virtualenv/bin/python setup.py develop",
        cwd => $code,
        creates => "$code/Deliver.egg-info",
        user => $user,
        group => $runner,
        require => [Exec['git clone deliver'], File['deliver-pythonenv-owner']];
    }

    # Live Config

    file { $live:
      ensure => 'directory',
      owner => $user,
      group => $runner,
      require => File[$directory]
    }

    file { 'deliver-log-link':
      ensure => symlink,
      owner => $user,
      group => $runner,
      path   => "$live/logging.conf",
      target => "$code/logging.conf",
      require => File[$live]
    }

    file { 'deliver-manifest-link':
      ensure => symlink,
      owner => $user,
      group => $runner,
      path   => "$live/manifest.json",
      target => "$code/manifest.json",
      require => File[$live]
    }

    file { "$live/members.json":
      ensure => present,
      owner => $user,
      group => $runner,
      source => "puppet:///modules/deliver/members.json",
      require => File[$live]
    }

    file { "$live/config.py":
      ensure => present,
      owner => $user,
      group => $runner,
      source => "puppet:///modules/deliver/config.py",
      require => File[$live]
    }

    exec {
      'deliver-binaries-copy':
        command => "cp $code/updater.py . \
        && cp $code/digester.py . \
        && cp $code/deliverdaemon.py .",
        cwd     => $live,
        path => ['/usr/bin', '/bin'],
        user => $user,
        group => $runner,
        require => File[$live]
    }

    # DB
    class { 'postgresql::server':
    }

    postgresql::db { $db_name:
      user => $db_user,
      password => $db_password,
    }
      
    # service { 'deliver':
    #   ensure => 'running',
    #   require => ...
    # }
  }
