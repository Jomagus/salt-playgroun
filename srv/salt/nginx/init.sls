# Alternativ kann man natürlich auch (offizielle) formulas verwenden, wie z.B.
# https://github.com/saltstack-formulas/nginx-formula/tree/master
# Davon habe ich aber abgesehen, da ich ja gerade selbst die eigentliche Arbeit
# machen möchte hier.

nginx_role:
  grains.list_present:
    - name: role
    - value: nginx

nginx:
  pkg.installed: []
  service.running:
    - enable: true
    - reload: true # reloade Server bei config changes, anstelle zu restarten
    - require:
      - pkg: nginx
      - user: nginx
      - group: nginx
    - watch: # Hier könnte man auch pkg: nginx integrieren, aber so finde ich es sauberer zu lesen
      - file: nginx_conf
      - file: /etc/nginx/sites-available/default
  group.present: []
  user.present:
    - gid: nginx
    - home: /var/www/html
    - shell: /bin/nologin
    - require:
      - group: nginx

nginx_conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - user: nginx
    - group: nginx
    - mode: 640 # Soll überhaup tirgendwer extern an dieser Config rumschreiben? Eig. 440 dann, oder?
    # Alternative zu `watch` auf dieses File in nginx service.running (Eig. wäre das watch_in - listen
    # verschiebt execution auf das Ende des state run).
    # - listen_in:
    #   - service: apache2
    - require:
      - pkg: nginx

/etc/nginx/sites-available/default:
  file.managed:
    - source: salt://nginx/files/default.jinja
    - template: jinja
    - user: nginx
    - group: nginx
    - mode: 664
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - require:
      - file: /etc/nginx/sites-available/default
  
/var/www/html:
  file.directory:
    - user: nginx
    - group: nginx
    - dirmode: 644
    - require:
      - group: nginx
      - user: nginx

/var/www/html/index.html:
  file.managed:
    - source: salt://nginx/files/index.html.jinja
    - template: jinja
    - user: nginx
    - group: nginx
    - mode: 664
    - require:
      - file: /var/www/html

# [TODO] per schedule automatisch SSL Zertifikate generieren und regelmäßig neu generieren
