class moin (
  $user = 'sirech',
  $directory = '/srv/www') inherits moin::settings {

    $full_path = "$directory/moin"
    $wiki = "$full_path/wiki"
    $virtualenv = "$full_path/pythonenv"
    $version = '2.7'
    $port = 5080

    $moin_version = '1.9.4'

    # Nginx vhost
    nginx::vhost { 'metaverse.hceris.com':
      template => 'moin/metaverse.erb',
      docroot => $full_path,
      port => $port,
      owner => $user,
      groupowner => 'uwsgi',
      require => User['uwsgi'],
    }

    # Startup scripts
    file { 'moin-start':
      ensure => 'present',
      path   => "/etc/init/moin.conf",
      content => template("moin/moin.conf.erb")
    }

    file { 'moin-link':
      ensure => symlink,
      path   => "/etc/init.d/moin",
      target => '/lib/init/upstart-job',
    }

    # Virtual env
    python::virtualenv { $virtualenv:
      ensure => present,
      version => $version,
    }

    python::pip { 'moin':
      ensure => present,
      virtualenv => $virtualenv,
      require => Python::Virtualenv[$virtualenv],
    }

    # uWSGI
    user { 'uwsgi':
      ensure => 'present',
    }

    package { 'uwsgi':
      ensure => 'present',
    }

    package { 'uwsgi-plugin-python':
      ensure => 'present',
    }

    # Moin config
    file { $wiki:
      ensure => 'directory',
      owner => $user,
      group => 'uwsgi',
      require => Nginx::Vhost['metaverse.hceris.com'],
    }

    file { 'uwsgi.xml':
      ensure => 'present',
      path   => "$wiki/uwsgi.xml",
      owner => $user,
      group => 'uwsgi',
      content => template("moin/uwsgi.xml.erb"),
      require => File[$wiki]
    }

    file { 'moin.wsgi':
      ensure => 'present',
      path   => "$wiki/moin.wsgi",
      owner => $user,
      group => 'uwsgi',
      content => template("moin/moin.wsgi.erb"),
      require => File[$wiki]
    }

    file { 'moin/logfile':
      ensure => 'present',
      path   => "$wiki/logfile",
      owner => $user,
      group => 'uwsgi',
      content => template("moin/logfile.erb"),
      require => File[$wiki]
    }

    file { '/var/log/moin':
      ensure => 'directory',
      owner => 'uwsgi',
      group => 'uwsgi',
    }

    file { 'wikiconfig.py':
      ensure => 'present',
      path   => "$wiki/wikiconfig.py",
      owner => $user,
      group => 'uwsgi',
      content => template("moin/wikiconfig.py.erb"),
      require => File[$wiki]
    }

    # Moin package
    exec {
      'moin-package-wget':
        command   => "wget http://static.moinmo.in/files/moin-${moin_version}.tar.gz -O /tmp/moin-package.tgz",
        path => ['/usr/bin', '/bin'],
        user => $user,
        group => 'uwsgi',
        logoutput => on_failure,
        creates   => "/tmp/moin-package.tgz",
        unless => "test -d $wiki/data",
        require   => Package['wget'];

      'moin-package-extract':
        command => 'tar -xzvf /tmp/moin-package.tgz',
        path => ['/usr/bin', '/bin'],
        cwd     => '/tmp',
        user => $user,
        group => 'uwsgi',
        creates => "/tmp/moin-${moin_version}",
        unless => "test -d $wiki/data",
        require => Exec['moin-package-wget'];

      'moin-package-move':
        command => "mv /tmp/moin-${moin_version}/wiki/data . && mv /tmp/moin-${moin_version}/wiki/underlay .",
        path => ['/usr/bin', '/bin'],
        cwd     => $wiki,
        user => $user,
        group => 'uwsgi',
        creates => "$wiki/data",
        unless => "test -d $wiki/data",
        require => Exec['moin-package-extract']
    }

    # Set permissions
    file { 'moin-pythonenv-owner':
      path => "$full_path/pythonenv",
      owner => $user,
      group => 'uwsgi',
      recurse => true,
      require => Python::Pip['moin']
    }

    # Start service
    service { 'moin':
      ensure => 'running',
      require => [File['moin-pythonenv-owner', 'moin-link', 'moin-start', 'uwsgi.xml', 'moin.wsgi', 'wikiconfig.py'], Exec['moin-package-move']]
    }
  }
