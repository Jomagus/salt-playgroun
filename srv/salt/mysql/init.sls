python3-mysqldb:
  pkg.installed: []

# Nicht unter der mariadb Id, da ein Modul (wie mysql_dabtabase) nicht
# doppelt verwendet werden kann.
# Siehe https://github.com/saltstack/salt/issues/35592
# secure_maria_db:
#   # Auskommentiert da interaktive EIngabe und ich es nicht für nötig hielt,
#   # es komplett zu automatisieren.
#   # - cmd.run:
#   #   - name: mariadb-secure-installation
#   #   - onchanges:
#   #     - pkg: mariadb

#   # Stattdessen habe ich einfach einen Teil der notwendigen Dinge
#   # welche mariadb-secure-installation macht, selbst gemacht.
#   # Es ist mir bewusst, dass dies nicht vollständig ist, es fehlt
#   # z. B. das erntfernen von Root Accounts, welche von außerhalb
#   # localhost zugreifen können. Aber für einen Test sollte es
#   # hoffentlich reichen.
#   mysql_database.absent:
#     - name: test
#     - require:
#       - pkg: mariadb
#       - pkg: python3-mysqldb
#   mysql_user.absent:
#     - name: ""
#     - require:
#       - pkg: mariadb
#       - pkg: python3-mysqldb

mariadb:
  pkg.installed:
    - name: mariadb-server
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: mariadb-server
  # mysql_database.present:
  #   - name: {{ pillar['mariadb']['database'] }}
  #   - require:
  #     - pkg: mariadb-server
  #     - pkg: python3-mysqldb
  # mysql_user.present:
  #   - name: {{ pillar['mariadb']['user'] }}
  #   - host: {{ pillar['mariadb']['host'] }}
  #   - password: {{ pillar['mariadb']['password'] }}
  #   - require:
  #     - mysql_database: {{ pillar['mariadb']['database'] }}
  # mysql_grants.present:
  #   - grant: ALL PRIVILEGES
  #   - database: {{ pillar['mariadb']['database'] }}.*
  #   - user: {{ pillar['mariadb']['user'] }}
  #   - host: {{ pillar['mariadb']['host'] }}
  #   - require:
  #     - mysql_user: {{ pillar['mariadb']['user'] }}

# [TODO] my.cnf Templaten!!!
