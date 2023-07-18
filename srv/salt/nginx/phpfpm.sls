include:
  - nginx
  - php

nginx_php_role:
  grains.list_present:
    - name: role
    - value: php
    # Durch diese require_in ist garantiert, dass bei dem Templateauswertung für
    # die nginx_conf die PHP Rolle gesetzt ist.
    - require_in:
      - file: nginx_conf
