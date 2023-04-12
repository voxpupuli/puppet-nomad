#!/bin/bash
PATH=/bin:/usr/bin:/sbin:/usr/sbin

systemctl stop nomad.service
install -o root -g root -m 644 /tmp/peers.json /var/lib/nomad/server/raft/peers.json
systemctl start nomad.service
