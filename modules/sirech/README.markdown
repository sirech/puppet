## User

This module prepares the user for the server

### settings.pp

The class `sirech::settings` should be provided. However, for security
reasons it is an ignored class. It should contain the following
variables:

    $password_hash
    
### authorized_keys

This file is used to enable access via _ssh_. Put it in the _files_ folder.
