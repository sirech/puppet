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

### Permissions

Set the correct permissions for the data directories by doing:

    chown -R $user:uwsgi 775 data
    chown -R $user:uwsgi 775 underlay

### System pages

The system pages have to be downloaded and installed manually. Go `to http://${wiki_address}/LanguageSetup`, install all the sites, and restart the wiki.
