import "base"

node server inherits basenode {
  include ntp

  class { 'nodejs':
    dev_package => true
  }
}
