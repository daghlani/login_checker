#!/bin/bash

# download script
wget https://raw.githubusercontent.com/daghlani/login_checker/main/login_checker.sh -o login_checker.sh


# chmod
chmod +x login_checker.sh


# download service
wget https://raw.githubusercontent.com/daghlani/login_checker/main/login_checker.service -o /etc/systemd/system/login_checker.service

# create log file
touch /var/log/login_checker.log

# service working
systemctl enable login_checker
systemctl start login_checker
