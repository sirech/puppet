node basenode {
  # So if some module defines a package then this crashes horribly,
  # which seems to me like sort of fucked up, but oh well.
  #
  # Remember to reinclude packages if the module does not exist anymore
  # ruby: build-essential, curl, git
  $basics = ['vim', 'ack-grep', 'wget', 'htop', 'tmux', 'zip']
  package { $basics: ensure => "latest" }

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }
}
