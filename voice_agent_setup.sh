#!/bin/bash
###########################################################################
#
#     COPYRIGHT (C) 2025
#
###########################################################################
#
#     Author:  Casey Cannady - me@caseycannady.com
#
###########################################################################
#
#     Script:  voice_agent_setup.sh
#     Version: 1.0
#     Created: 01/22/2025
#     Updated: 01/23/2025
#
###########################################################################

#
# Let's get started!
#
echo " "
echo "[*** STARTING | voice_agent_setup.sh | `date` ***]"

#
# Update system
#
sudo apt update && sudo apt upgrade -y

#
# Install system dependencies
#
sudo apt install -y curl wget git python3 python3-pip nodejs npm

#
# Install Node.js 18.x (n8n requirement)
#
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

#
# Install n8n globally
#
sudo npm install -g n8n

#
# Install Python dependencies
#
pip3 install --upgrade pip
pip3 install openai pinecone-client google-auth google-auth-oauthlib \
     google-auth-httplib2 google-api-python-client python-telegram-bot

#
# Create configuration directory
#
mkdir -p ~/.n8n
mkdir -p ~/ai-agent-config

#
# Create environment file
#
cat > ~/.n8n/.env << EOL
N8N_ENCRYPTION_KEY=$(openssl rand -hex 24)
OPENAI_API_KEY=your_openai_api_key
PINECONE_API_KEY=your_pinecone_api_key
SERPAPI_API_KEY=your_serpapi_key
TELEGRAM_BOT_TOKEN=your_telegram_token
GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/credentials.json
EOL

#
# Create systemd service for n8n
#
sudo tee /etc/systemd/system/n8n.service << EOL
[Unit]
Description=n8n Workflow Automation
After=network.target

[Service]
Type=simple
User=$USER
Environment=NODE_ENV=production
ExecStart=/usr/bin/n8n start
Restart=always

[Install]
WantedBy=multi-user.target
EOL

#
# Start n8n service
#
sudo systemctl enable n8n
sudo systemctl start n8n

#
# Check if reboot is required and notify user.
#
echo " ";
if [ -f /var/run/reboot-required ] 
then
    echo "[*** Attention $USER: you must reboot your machine ***]"
else
    echo "[*** Attention $USER: your device has been updated ***]"
fi

#
# We're done!
#
echo " "
echo "[*** FINISHED | voice_agent_setup.sh | `date` ***]"
echo " "
exit