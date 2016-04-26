#!/bin/bash
# add ansible user to sudoers
#

if [ ! -f '/etc/sudoers' ]; then
  echo please install sudo first!
  exit 1
fi

chmod +w /etc/sudoers
sed -i "s/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/" /etc/sudoers
chmod -w /etc/sudoers
echo change sudoers success
