# Login Checker 

#### A project to check who is logged in and send alert to bale messenger bot or group.

## Install
To install this script, run this command:

```bash
bash <(curl -s https://raw.githubusercontent.com/daghlani/login_checker/main/login_checker_installer.sh)
```

## Configuration
You must first change `token`, `chat_id` and `server_name` of you server.

- login_checker.sh

Change this values:

```bash
SRV_NAME=<server_name>
CHID=<chat_id>
TKN=<token>
```

- login_checker.service

Now change the location of your script in this file

```bash
vi /etc/systemd/system/login_checker.service
```

Now change this section:

```bash
ExecStart=bash /<path_to_script>/login_checker.sh
```

## Start
After config the files, to start the script you can run this commands:

```bash
sudo systemctl enable login_checker

sudo systemctl start login_checker
```

