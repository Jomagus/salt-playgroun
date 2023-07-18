include:
  - git
  - php
  - php.composer
  - nginx.phpfpm

php_dependencies:
  pkg.installed:
    - pkgs:
      - php8.2-sqlite3
      - php8.2-mysql
      - php8.2-xml
      - php8.2-zip
      - unzip
    - require_in:
      - service: php8.2-fpm

checkout_project:
  git.detached:
    - name: https://github.com/symfony/demo.git
    - user: nginx
    - rev: main
    - target: /opt/app
    - require:
      - pkg: git

/opt/app:
  composer.installed:
    # Solange die APP_ENV standardmäßig auf dev steht, wird das hier nicht funktionieren
    # - no_dev: true
    - optimize: true
    - user: nginx
    - require:
      - cmd: install_composer
      - git: checkout_project
      - pkg: php_dependencies

/var/www/app:
  file.symlink:
    - target: /opt/app/public
    - user: nginx
    - group: nginx
    - require:
      - composer: /opt/app
