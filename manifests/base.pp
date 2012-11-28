node basenode {
  $basics = ["curl", "vim"]
  package { $basics: ensure => "latest" }
}
