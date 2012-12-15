node basenode {
  $basics = ['curl', 'vim', 'git', 'ack-grep', 'wget', 'htop', 'tmux', 'zip']
  package { $basics: ensure => "latest" }

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }
}
