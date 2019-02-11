[![Build Status](https://travis-ci.org/singleplatform-eng/ansible-role-gunicorn-service.svg?branch=master)](https://travis-ci.org/singleplatform-eng/ansible-role-gunicorn-service)

Gunicorn
=========

This role is designed to provide all the needed directories, config files, service units, and service handlers for managing gunicorn services using systemd on Ubuntu. It does not manage the installation of a gunicorn binary, users, groups, or wsgi applications.


Requirements 
------------

Ubuntu 18.04+


Role Variables
--------------
Defaults
```
gunicorn_config_dir: /etc/gunicorn
gunicorn_log_dir: /var/log/gunicorn
gunicorn_systemd_service_dir: /etc/systemd/system
gunicorn_access_logfile: "{{gunicorn_log_dir}}/access.log"
gunicorn_python_path: /usr

gunicorn_tmp_dir: /run/lock
gunicorn_read_timeout: 60
gunicorn_user: gunicorn

gunicorn_service_name: gunicorn
gunicorn_bind_port: '127.0.0.1:8000'

gunicorn_start_command: "{{gunicorn_python_path}}/bin/gunicorn"
gunicorn_install_service: true
gunicorn_enable_service: false

gunicorn_environment: {}
```
Required Vars
```
gunicorn_app_dir
gunicorn_wsgi_module_name
gunicorn_state - when gunicorn_enable_service=True
```

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: localhost
      vars:
	 gunicorn_app_dir: /srv/django
	 gunicorn_wsgi_module_name: django_app.wsgi:application
	 gunicorn_user: django
	 gunicorn_environment: { DJANGO_SETTINGS_MODULE: django.settings, HOME: "{{gunicorn_app_dir}}", PATH: django_virtualenv/bin }
      roles:
         - { role: ansible-role-gunicorn }

Author Information
------------------

[SinglePlatform Engineering](http://engineering.singleplatform.com/)

License
-------

BSD 3-Clause
