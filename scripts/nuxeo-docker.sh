#! /bin/bash

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y htop supervisor curl


# Install Supervisor
apt-get install -y supervisor
systemctl enable supervisor
systemctl start supervisor

useradd -d /opt/nuxeo -p nuxeo -s /bin/bash nuxeo
DEBIAN_FRONTEND=noninteractive apt-get install -y acpid openjdk-8-jdk libreoffice imagemagick poppler-utils ffmpeg ffmpeg2theora ufraw libwpd-tools perl locales pwgen dialog supervisor unzip vim htop
curl -sSL http://cdn.nuxeo.com/nuxeo-${NUXEO_VERSION}/nuxeo-server-${NUXEO_VERSION}-tomcat.zip -o /tmp/nuxeo-distribution-tomcat.zip
unzip -q -d /opt /tmp/nuxeo-distribution-tomcat.zip 
mv /opt/nuxeo-server-${NUXEO_VERSION}-tomcat /opt/nuxeo
chown -R nuxeo /opt/nuxeo
chmod +x /opt/nuxeo/bin/*ctl /opt/nuxeo/bin/*.sh 
rm -rf /tmp/nuxeo-distribution* 

# Install Supervisor's configuration file
tee /etc/supervisor/conf.d/supervisord.conf > /dev/null <<'CONFIG_EOF'
[supervisord]
nodaemon=true

[program:nuxeo]
user=nuxeo
directory=/opt/nuxeo
command=/opt/nuxeo/bin/nuxeoctl console
autostart=true
autorestart=true
CONFIG_EOF
