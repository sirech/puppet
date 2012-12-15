## Deliver module

This module installs an instance of the
[deliver mailing list](http://www.github.com/sirech/deliver). It also
installs _postfix_ and _postgresql_.

### settings.pp

The class `deliver::settings` should be provided. However, for
security reaosns it is an ignored class. It should contain the
following variables:

    $mail_sender
    $mail_host
    $mail_machine
    $mail_password
    $mail_password_hash
    $db_name
    $db_user
    $db_password
    
### Files

The files _members.json_ and _config.py_ are also ignored, as they may
contain personal information.
