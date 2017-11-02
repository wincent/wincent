#!/bin/bash

# {{ ansible_managed }}

{% if 'personal' in group_names %}
echo 'No presync checks needed.'
exit 0
{% endif %}
{% if 'work' in group_names %}
WIFI=$(networksetup -getairportnetwork en0 | awk '{ print $NF }')

if [ "$WIFI" = lighthouse ]; then
  echo 'On lighthouse: allowing sync.'
  exit 0
elif ifconfig utun1 2> /dev/null | grep -q -e '\binet\b'; then
  echo 'On VPN: allowing sync.'
  exit 0
elif ifconfig utun2 2> /dev/null | grep -q -e '\binet\b'; then
  echo 'On VPN: allowing sync.'
  exit 0
else
  echo 'Not on corporate network: disallowing sync.'
  exit 1
fi
{% endif %}
