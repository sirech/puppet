node basenode {
  $basics = ['curl', 'vim', 'git', 'ack-grep']
  package { $basics: ensure => "latest" }

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }
}
