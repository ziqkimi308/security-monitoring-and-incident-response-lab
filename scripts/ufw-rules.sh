#!/bin/bash

sudo ufw status
sudo ufw enable

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow from 192.168.0.0/24 to any port 53   # Any network from that IP range allow # DNS from lab only

sudo ufw status verbose > ufw-status.txt