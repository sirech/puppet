class shell (
  $user = 'sirech') {

    $home = "/home/$user"

    exec { 'git clone shell':
      command => "git clone git://github.com/sirech/shell $home/shell",
      creates => "$home/shell",
      user => $user,
      path => '/usr/bin',
      require => User[$user]
    }

    file { 'bin-link':
      ensure => symlink,
      path   => "$home/bin",
      target => "$home/shell/scripts",
      require => Exec['git clone shell']
    }

    file { 'vimrc-link':
      ensure => symlink,
      path   => "$home/.vimrc",
      target => "$home/shell/vimrc",
      require => Exec['git clone shell']
    }

    file { 'ackrc-link':
      ensure => symlink,
      path   => "$home/.ackrc",
      target => "$home/shell/ackrc",
      require => Exec['git clone shell']
    }

    file { 'inputrc-link':
      ensure => symlink,
      path   => "$home/.inputrc",
      target => "$home/shell/inputrc",
      require => Exec['git clone shell']
    }

    file { 'tmux.conf-link':
      ensure => symlink,
      path   => "$home/.tmux.conf",
      target => "$home/shell/tmux.conf",
      require => Exec['git clone shell']
    }

    file { 'gitconfig-link':
      ensure => symlink,
      path   => "$home/.gitconfig",
      target => "$home/shell/git/gitconfig",
      require => Exec['git clone shell']
    }

    file { 'secrets':
      ensure => 'present',
      path   => "$home/.secrets",
      content => template("shell/secrets.erb")
    }

    file { 'bashrc':
      ensure => 'present',
      path   => "$home/.bashrc",
      content => template("shell/bashrc.erb")
    }
  }
