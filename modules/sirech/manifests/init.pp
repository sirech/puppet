class sirech () inherits sirech::settings {

  $user = 'sirech'

  user { $user:
    ensure => 'present',
    shell => '/bin/bash',
    groups => ['adm', 'sudo'],
    managehome => true,
  }

  $home = "/home/$user"
  $ssh = "$home/.ssh"

  file { $ssh:
    ensure => 'directory',
    owner => $user,
    group => $user
  }

  file { "$ssh/authorized_keys":
    ensure => present,
    owner => $user,
    group => $user,
    mode => 660,
    source => "puppet:///modules/sirech/authorized_keys",
    require => File[$ssh]
  }

  file { "$ssh/id_rsa":
    ensure => present,
    owner => $user,
    group => $user,
    mode => 660,
    source => "puppet:///modules/sirech/id_rsa",
    require => File[$ssh]
  }

  file { "$ssh/id_rsa.pub":
    ensure => present,
    owner => $user,
    group => $user,
    mode => 660,
    source => "puppet:///modules/sirech/id_rsa.pub",
    require => File[$ssh]
  }

  exec { "$user password":
      command => "usermod --password \'$password_hash\' $user",
      path => '/usr/sbin',
      require => User[$user]
  }
}
