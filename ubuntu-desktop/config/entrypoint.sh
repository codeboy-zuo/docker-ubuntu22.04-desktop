#!/bin/sh
## initialize environment
if [ ! -f "/config/init_flag" ]; then
    # create user
    groupadd -g $GID $USER
    useradd --create-home --no-log-init -u $UID -g $GID $USER
    usermod -aG sudo $USER
    echo "$USER:$PASSWORD" | chpasswd
    chsh -s /bin/bash $USER
    # config nomachine
    sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg
    sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "xset s off && /usr/bin/startxfce4"' /usr/NX/etc/node.cfg
    # vgl for user
    echo "export PATH=/usr/NX/scripts/vgl:\$PATH" >> /home/$USER/.bashrc
    # extra env init for developer
    if [ -f "/config/env_init.sh" ]; then
        bash /config/env_init.sh
    fi
    # custom env init for user
    if [ -f "/config/custom_env_init.sh" ]; then
        bash /config/custom_env_init.sh
    fi
    echo  "ok" > /config/init_flag
fi
## startup
# custom startup for user
if [ -f "/config/custom_startup.sh" ]; then
    bash /config/custom_startup.sh
fi
# start sshd & remote desktop
/usr/sbin/sshd
if [ "${REMOTE_DESKTOP}" = "nomachine" ]; then
    echo "start nomachine"
    /etc/NX/nxserver --startup
    tail -f /usr/NX/var/log/nxserver.log
else
    echo "unsupported remote desktop: $REMOTE_DESKTOP"
fi
