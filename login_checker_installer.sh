#!/bin/bash

# download script
sudo curl -O https://raw.githubusercontent.com/daghlani/login_checker/main/login_checker.sh


# chmod
sudo chmod +x login_checker.sh


# download service
sudo curl -o /etc/systemd/system/login_checker.service https://raw.githubusercontent.com/daghlani/login_checker/main/login_checker.service

# create log file
sudo touch /var/log/login_checker.log

# service working
# systemctl enable login_checker
# systemctl start login_checker
