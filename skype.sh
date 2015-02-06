#!/bin/bash
sudo sh -c "echo 'deb http://archive.canonical.com/ubuntu/ trusty partner' >> /etc/apt/sources.list.d/canonical_partner.list"
sudo apt-get update
sudo apt-get install skype