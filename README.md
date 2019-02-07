Gunicorn
=========

This role is designed to provide all the needed directories, config files, service units, and service handlers for managing gunicorn services using systemd on Ubuntu. It does not manage the installation of a gunicorn binary, users, groups, or wsgi applications.


Requirements 
------------

Ubuntu 18.04+


Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

Author Information
------------------

[SinglePlatform Engineering](http://engineering.singleplatform.com/)

License
-------

BSD 3-Clause
