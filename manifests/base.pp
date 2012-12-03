node basenode {
  $basics = ['curl', 'vim', 'git', 'ack-grep', 'wget']
  package { $basics: ensure => "latest" }

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }
}
