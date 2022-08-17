#!/bin/bash
yum update -y
rpm --import https://yum.corretto.aws/corretto.key 

curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo

yum install -y java-18-amazon-corretto-devel

adduser minecraft
mkdir /opt/minecraft
mkdir /opt/minecraft/server
chown -R minecraft:minecraft /opt/minecraft

cd /opt/minecraft/server
wget https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar

cat >/etc/systemd/system/minecraft.service <<EOL
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=minecraft
Nice=5
KillMode=none
SuccessExitStatus=0 1
InaccessibleDirectories=/root /sys /srv /media -/lost+found
NoNewPrivileges=true
WorkingDirectory=/opt/minecraft/server
ReadWriteDirectories=/opt/minecraft/server
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
ExecStop=/opt/minecraft/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p strong-password stop

[Install]
WantedBy=multi-user.target
EOL

chmod 664 /etc/systemd/system/minecraft.service

cat >/opt/minecraft/server/eula.txt <<EOL
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://aka.ms/MinecraftEULA).
#Sun Aug 07 23:10:00 UTC 2022
eula=true
EOL

systemctl start minecraft.service