#! /bin/bash

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y htop supervisor

# Install Supervisor
sudo apt-get install -y supervisor
sudo systemctl enable supervisor
sudo systemctl start supervisor

sudo useradd -d /opt/nuxeo -p nuxeo -s /bin/bash nuxeo
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y acpid openjdk-8-jdk libreoffice imagemagick poppler-utils ffmpeg ffmpeg2theora ufraw libwpd-tools perl locales pwgen dialog supervisor unzip vim htop
curl -sSL http://cdn.nuxeo.com/nuxeo-${NUXEO_VERSION}/nuxeo-server-${NUXEO_VERSION}-tomcat.zip -o /tmp/nuxeo-distribution-tomcat.zip
sudo unzip -q -d /opt /tmp/nuxeo-distribution-tomcat.zip 
sudo mv /opt/nuxeo-server-${NUXEO_VERSION}-tomcat /opt/nuxeo
sudo chown -R nuxeo /opt/nuxeo
sudo chmod +x /opt/nuxeo/bin/*ctl /opt/nuxeo/bin/*.sh 
sudo rm -rf /tmp/nuxeo-distribution* 

# Install Supervisor's configuration file
sudo tee /etc/supervisor/conf.d/nuxeo.conf > /dev/null <<'CONFIG_EOF'
[program:nuxeo]
user=nuxeo
directory=/opt/nuxeo
command=/opt/nuxeo/bin/nuxeoctl console
autostart=true
autorestart=true
CONFIG_EOF

# Install AWS CloudWatch Logs Agent
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py
#./awslogs-agent-setup.py -n -r us-east-1

#echo "Fetching Cloudwatch Agent..."
#cd /tmp
#curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
#
#echo "Installing Cloudwatch Agent..."
#
#chmod +x awslogs-agent-setup.py
#sudo mv awslogs-agent-setup.py /usr/bin


