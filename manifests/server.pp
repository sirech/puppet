import "base"

node server inherits basenode {
  include ntp

  class { 'nodejs':
    dev_package => true
  }

  include nginx

  class { 'python':
    version => '2.7',
    virtualenv => true,
  }
}
