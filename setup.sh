#!/bin/bash

set -e

# Update the system
echo "Updating the system..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Chrome
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt-get install -f -y
rm google-chrome-stable_current_amd64.deb

# Install Git
echo "Installing Git..."
sudo apt install git-all -y
git config --global --add --bool push.autoSetupRemote true

# Install Curl
echo "Installing Curl..."
sudo apt install curl -y

# Install Docker
echo "Installing Docker..."
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo groupadd docker || true
sudo gpasswd -a $USER docker

# Install VS Code
echo "Installing Visual Studio Code..."
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code -y

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Slack
echo "Installing Slack..."
sudo snap install slack

# Install Barrier
echo "Installing Barrier..."
sudo apt install barrier -y

# Install Node.js and npm
echo "Installing Node.js and npm..."
sudo apt install nodejs npm -y

# Install AWS CDK
echo "Installing AWS CDK..."
sudo npm install -g aws-cdk

# Install Solaar
echo "Installing Solaar..."
sudo apt install solaar -y

# Install Python and Pip
echo "Installing Python and Pip..."
sudo apt install python3.12 python3-pip -y

# Install Pipx
echo "Installing Pipx..."
sudo apt install pipx -y
pipx ensurepath

# Install Poetry and Pytest
echo "Installing Poetry and Pytest..."
pipx install poetry
pipx install pytest

echo "Setup complete! Please restart your session to apply the changes."
