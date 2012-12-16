class shell (
  $user = 'sirech') {

    $home = "/home/$user"

    exec { 'git clone shell':
      command => 'git clone git://github.com/sirech/shell',
      cwd => $home,
      creates => "$home/shell",
      user => $user,
      group => $user,
      path => '/usr/bin',
      require => User[$user]
    }

    file { 'bin-link':
      ensure => symlink,
      path   => "$home/bin",
      target => "$home/shell/scripts",
      owner => $user,
      group => $user,
      require => Exec['git clone shell']
    }

    file { 'vimrc-link':
      ensure => symlink,
      path   => "$home/.vimrc",
      target => "$home/shell/vimrc",
      owner => $user,
      group => $user,
      require => Exec['git clone shell']
    }

    file { 'ackrc-link':
      ensure => symlink,
      path   => "$home/.ackrc",
      target => "$home/shell/ackrc",
      owner => $user,
      group => $user,
      require => Exec['git clone shell']
    }

    file { 'inputrc-link':
      ensure => symlink,
      path   => "$home/.inputrc",
      target => "$home/shell/inputrc",
      owner => $user,
      group => $user,
      require => Exec['git clone shell']
    }

    file { 'tmux.conf-link':
      ensure => symlink,
      path   => "$home/.tmux.conf",
      target => "$home/shell/tmux.conf",
      owner => $user,
      group => $user,
      require => Exec['git clone shell']
    }

    file { 'gitconfig-link':
      ensure => symlink,
      path   => "$home/.gitconfig",
      target => "$home/shell/git/gitconfig",
      owner => $user,
      group => $user,
      require => Exec['git clone shell']
    }

    file { 'secrets':
      ensure => 'present',
      path   => "$home/.secrets",
      owner => $user,
      group => $user,
      source => "puppet:///modules/shell/secrets"
    }

    file { 'bashrc':
      ensure => 'present',
      path   => "$home/.bashrc",
      owner => $user,
      group => $user,
      content => template("shell/bashrc.erb")
    }
  }
