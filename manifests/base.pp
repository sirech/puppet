node basenode {
  $basics = ['curl', 'vim', 'git']
  package { $basics: ensure => "latest" }

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }
}
