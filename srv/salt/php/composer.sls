# Aus https://docs.saltproject.io/en/latest/ref/states/all/salt.states.composer.html
# mit Fix aus https://github.com/saltstack/salt/issues/30725
get_composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - env:
      - HOME: /root/

install_composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - watch:
      - cmd: get_composer
