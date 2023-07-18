php_role:
  grains.list_present:
    - name: role
    - value: php

php_repo_tools:
    pkg.installed:
    - name: apt-transport-https

php_ppa:
  pkgrepo.managed:
    - name: deb https://packages.sury.org/php/ bullseye main # bullseye ist alternativ in {{ grains['oscodename'] }}
    - ppa: ondrej/php
    - key_url: https://packages.sury.org/php/apt.gpg
    - file: /etc/apt/sources.list.d/ondrej-php.list
    - __env__:
      - LC_ALL: C.UTF-8
    - require:
      - pkg: php_repo_tools
    - require_in:
      - pkg: php8.2-fpm
    
php8.2-fpm:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: php8.2-fpm
    - watch:
      - file: php_pool_conf

# Notwendig um listen Socket Permissions für nginx user zu setzen
php_pool_conf:
  file.managed:
    - name: /etc/php/8.2/fpm/pool.d/www.conf
    - source: salt://php/files/www.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php8.2-fpm

# Aktuell templaten wir php.ini nicht und verwendeten defaults
