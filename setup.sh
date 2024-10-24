#!/bin/bash

set -e

# Update the system
echo "===================================="
echo "Step 1: Updating the system..."
sudo apt-get update 
sudo apt-get upgrade -y 
echo "System updated successfully!"
echo "===================================="

# Install Chrome
echo "Step 2: Installing Google Chrome..."
if ! dpkg -l | grep -q google-chrome-stable; then
    echo "Google Chrome is not installed. Installing..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt-get install -f -y
    rm google-chrome-stable_current_amd64.deb
    echo "Google Chrome installed successfully!"
else
    echo "Google Chrome is already installed."
fi
echo "===================================="

# Install Git
echo "Step 3: Installing Git..."
echo "Installing Git..."
sudo apt install git-all -y
git config --global --add --bool push.autoSetupRemote true
echo "Git installed successfully!"
echo "===================================="

# Install Curl
echo "Step 4: Installing Curl..."
sudo apt install curl -y
echo "Curl installed successfully!"
echo "===================================="

# Install Unzip
echo "Step 5: Installing unzip..."
sudo apt install unzip -y
echo "Unzip installed successfully!"
echo "===================================="

# Install Docker
echo "Step 6: Installing Docker..."
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing..."

    # Install dependencies
    sudo apt-get install -y ca-certificates curl

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Set up the Docker stable repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update the package database
    sudo apt-get update

    # Install Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Create the docker group if it doesn't exist
    sudo groupadd docker || true
    sudo gpasswd -a $USER docker

    echo "Docker has been installed."
else
    echo "Docker is already installed."
fi
echo "===================================="

# Install VS Code
echo "Step 7: Installing Visual Studio Code..."
if ! command -v code &> /dev/null; then
    echo "Visual Studio Code is not installed. Installing..."

    # Install necessary dependencies
    sudo apt install -y software-properties-common apt-transport-https wget

    # Import the Microsoft GPG key
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -

    # Add the VS Code repository
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

    # Update the package database
    sudo apt update

    # Install Visual Studio Code
    sudo apt install -y code

    echo "Visual Studio Code has been installed."
else
    echo "Visual Studio Code is already installed."
fi
echo "===================================="

# Install AWS CLI
echo "Step 8: Installing AWS CLI..."
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Installing..."

    # Download and install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip

    echo "AWS CLI has been installed."
else
    echo "AWS CLI is already installed."
fi
echo "===================================="

# Install kubectl
echo "Step 9: Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Installing..."

    # Download and install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    echo "kubectl has been installed."
else
    echo "kubectl is already installed."
fi
echo "===================================="

# Install Barrier
echo "Step 10: Installing Barrier..."
sudo apt install barrier -y
echo "Barrier installed successfully!"
echo "===================================="

# Install Node.js and npm
echo "Step 11: Installing Node.js and npm..."
sudo apt install nodejs npm -y
echo "Node.js and npm installed successfully!"
echo "===================================="

# Install AWS CDK
echo "Step 12: Installing AWS CDK..."
if ! command -v cdk &> /dev/null; then
    echo "AWS CDK is not installed. Installing..."
    sudo npm install -g aws-cdk
    echo "AWS CDK has been installed."
else
    echo "AWS CDK is already installed."
fi
echo "===================================="

# Install Solaar
echo "Step 13: Installing Solaar..."
sudo DEBIAN_FRONTEND=noninteractive apt install solaar -y
echo "Solaar installed successfully!"
echo "===================================="

# Install Python and Pip
echo "Step 14: Installing Python and Pip..."
sudo apt install software-properties-common -y 
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.12 -y
sudo apt install python3-pip -y
echo "Python and Pip installed successfully!"
echo "===================================="

# Install Pipx
echo "Step 15: Installing Pipx..."
sudo apt install pipx -y
pipx ensurepath
echo "Pipx installed successfully!"
echo "===================================="

# Install Poetry and Pytest
# pipx install poetry
# pipx install pytest

# Install and setup ZSH
echo "Step 16: Installing and setting up ZSH..."
if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing..."
    sudo apt-get install zsh -y

    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # Clone the powerlevel10k theme
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

    # Set the theme in .zshrc
    sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

    # fonts
    mkdir -p "$HOME/.local/share/fonts"
    FONT_URLS=(
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    )
    for url in "${FONT_URLS[@]}"; do
        FONT_FILE=$(basename "$url")
        if [ ! -f "$FONT_DIR/$FONT_FILE" ]; then
            echo "Downloading $FONT_FILE..."
            curl -fLo "$FONT_DIR/$FONT_FILE" "$url"
        else
            echo "$FONT_FILE already exists."
        fi
    done
    fc-cache -f -v
    
    # Configure gnome terminal
    echo "Configuring Gnome Terminal..."
    PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'") &&
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'MesloLGS NF Regular 12'
    
    # plugins
    echo "Downloading plugin zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    sed -i 's/^plugins=(.*)$/plugins=(git zsh-autosuggestions)/' ~/.zshrc && source ~/.zshrc
else
    echo "Zsh is already installed."
fi
echo "===================================="

# Setup complete!
echo "Setup complete! Please restart your session to apply the changes."
