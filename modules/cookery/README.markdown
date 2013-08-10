## Cookery module

This module installs an instance of the
[cookery app](http://www.github.com/sirech/cookery). It also installs
_thin_ and _postgresql_.

### settings.pp

The class `cookery::settings` should be provided. However, for
security reasons it is an ignored  class. It should contain the
following variables:

    $db_name
    $db_user
    $db_password
