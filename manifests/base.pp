node basenode {
  $basics = ["curl", "vim"]
  package { $basics: ensure => "latest" }

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }

  class { 'apt::update':
    stage => 'first'
  }
}
