base:
  '*':
    - core

  'salt-master':
    - git
  
  'minion-01':
    - nginx
  
  'minion-02':
    - nginx
    - nginx.phpfpm
    - app
  
  'minion-03':
    - mysql
