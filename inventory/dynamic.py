#!/usr/bin/python

import re
import socket

host = socket.gethostname()

if host == 'glh-mbp':
    group = 'work'
elif host == 'retiro.local':
    group = 'personal'
elif re.match(r'dev(vm)?\d+', host):
    group = 'devservers'
else:
    group = 'local'

print """
{
  "%s": {
    "hosts": [
      "localhost"
    ],
    "vars": {
      "ansible_connection": "local"
    }
  }
}
""" % group
