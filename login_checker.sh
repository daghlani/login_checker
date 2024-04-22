#!/bin/bash
# set -x
# Initialize an empty associative array to keep track of logged-in users
declare -A logged_in_users
SRV_NAME=<server_name>
CHID=<chat_id>
TKN=<token>
LOGF=/var/log/check_login.log


while true
do
    # Get all users
    all_users=$(cut -d: -f1 /etc/passwd | grep -v '^root$')

    # Check if any user is logged in
    for user in $all_users
    do
        if [ $(who | grep -c "^$user ") -gt 0 ]; then
            # Check if the user is not already in the list of logged-in users
	    if [ -z "${logged_in_users[$user]}" ]; then
            #if [ -z ${logged_in_users[$user]} ]; then
                login_time=$(date '+%Y.%m.%d-%H:%M:%S')
		user_ip=$(who | awk -v u=$user '$1 == u {print $5}'|sed 's/(//g'|sed 's/)//g')
                # echo "User $user logged in from $user_ip at $login_time."
                echo "User $user logged in from $user_ip at $login_time." > $LOGF
                curl -X POST "https://tapi.bale.ai/bot"$TKN"/sendMessage" -H 'Content-Type: application/json' -d '{"chat_id": "'$CHID'", "text": "🔑 *'$SRV_NAME' Server Login:* 🔺 \n\n👤 *User:* '$user' \n\n📍 *From: * _'$user_ip'_ \n\n⏰ *At: * '$login_time' "}'
                # Add the user to the list of logged-in users along with login time and IP
                logged_in_users[$user]="$user_ip $login_time"
            fi
        else
            # Check if the user was logged in previously
            if [ ! -z "${logged_in_users[$user]}" ]; then
            #if [ ! -z ${logged_in_users[$user]} ]; then
                logout_time=$(date '+%Y.%m.%d-%H:%M:%S')
		user_ip=$(echo ${logged_in_users[$user]} | awk '{print $1}'|sed 's/(//g'|sed 's/)//g')
                login_time=$(echo ${logged_in_users[$user]} | awk '{print $2}')
                # echo "User $user logged out from $user_ip at $logout_time. Logged in since: $login_time."
                echo "User $user logged out from $user_ip at $logout_time. Logged in since: $login_time." > $LOGF
                curl -X POST "https://tapi.bale.ai/bot"$TKN"/sendMessage" -H 'Content-Type: application/json' -d '{"chat_id": "'$CHID'", "text": "🔑 *'$SRV_NAME' Server Logout:* 🟢 \n\n👤 *User:* '$user' \n\n📍 *From: * _'$user_ip'_ \n\n⏰ *At: * '$logout_time' \n\n⌛ *Logged in since:* '$login_time'"}'
                # Remove the user from the list of logged-in users
                unset logged_in_users[$user]
            fi
        fi
    done

    # Wait for 30 seconds before checking again
    sleep 2
done

