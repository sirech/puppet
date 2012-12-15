## Moin module

This module installs an instance of the _MoinMoin_ wiki. It is
configured to run under _nginx_ using _uwsgi_.

### settings.pp

The class `moin::settings` should be provided. However, for security
reasons it is an ignored class. It should contain the following
variables:

    $admin_user
    $mail_host
    $mail_address
    $mail_full_address
    $mail_password
    
### data

The actual data should be taken from a backup and put in the folder
`data`, under the path defined by `$wiki`.