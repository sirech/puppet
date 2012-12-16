class auto-complete (
  $directory = '/srv/www',
  $user = 'sirech') {

    $auto_start = 'auto-complete-server'
    $full_path = "$directory/stock-display"

    nginx::vhost { 'stockdisplay.hceris.com':
      template => 'auto-complete/auto-complete.erb',
      docroot => $full_path,
      port => 3023
    }

    file { 'auto-start':
      ensure => 'present',
      path   => "/etc/init/$auto_start.conf",
      content => template("auto-complete/$auto_start.conf.erb")
    }

    file { 'auto-start-link':
      ensure => symlink,
      path   => "/etc/init.d/$auto_start",
      target => '/lib/init/upstart-job',
    }

    exec { 'git clone stock-display':
      command => 'git clone git://github.com/sirech/stock-display.git',
      cwd => $directory,
      creates => $full_path,
      user => $user,
      path => '/usr/bin',
      require => File['/srv/www']
    }

    exec { 'npm install stock-display':
      command => 'npm install -d',
      cwd => "$full_path/auto-complete-server",
      creates => "$full_path/auto-complete-server/node_modules",
      path => '/usr/bin',
      require => Exec['git clone stock-display']
    }

    file { 'auto-start-packages':
      path => "$full_path/auto-complete-server/node_modules",
      owner => $user,
      group => $user,
      recurse => true,
      require => Exec['npm install stock-display'],
    }

    service { 'auto-complete-server':
      ensure => 'running',
      require => File['auto-start', 'auto-start-link', 'auto-start-packages']
    }
  }
