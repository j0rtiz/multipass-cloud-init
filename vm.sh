#!/bin/bash

echo "# Chaves..."
sudo -u $USER ssh-keygen -t rsa -C $AZURE_EMAIL -f $HOME/.ssh/id_rsa -N "" -q

echo "# NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | sudo -u $USER bash
source $HOME/.nvm/nvm.sh
nvm install $NODE_VERSION

echo "# Docker..."
curl -fsSL https://get.docker.com | sudo -u $USER bash
sudo usermod -aG docker $USER
newgrp docker

echo "# Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "# Docker Compose Command Completion..."
sudo curl -L https://raw.githubusercontent.com/docker/compose/$DOCKER_COMPOSE_COMMAND_COMPLETION_VERSION/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
source $HOME/.bashrc

echo "# Config..."
echo -e "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
sudo -u $USER mkdir $HOME/$WORKSPACE
sudo -u $USER touch $HOME/.sudo_as_admin_successful
sudo -u $USER echo -e "Host $AZURE_SERVER\n   StrictHostKeyChecking no" > $HOME/.ssh/config
sudo -u $USER echo -e "\ngreen=\`tput setaf 2\`" >> $HOME/.bashrc
sudo -u $USER echo -e "blue=\`tput setaf 4\`" >> $HOME/.bashrc
sudo -u $USER echo -e "reset=\`tput sgr0\`" >> $HOME/.bashrc
sudo -u $USER echo -e "\nsudo ifconfig eth0 mtu 1350" >> $HOME/.bashrc
sudo -u $USER echo -e "cd $HOME/$WORKSPACE && clear" >> $HOME/.bashrc
sudo -u $USER echo -e "echo \"\${green}Chave Pública: \${blue}\$(cat $HOME/.ssh/id_rsa.pub)\${reset}\"" >> $HOME/.bashrc
sudo -u $USER echo -e "echo \"\${green}Swagger: \${blue}https://\$(hostname -I | awk '{print \$1}'):3000/api/docs/\${reset}\"" >> $HOME/.bashrc
sudo -u $USER echo -e "registry=https://$AZURE_URL/registry/\n\nalways-auth=true\n\n; begin auth token\n//$AZURE_URL/registry/:username=$AZURE_USER\n//$AZURE_URL/registry/:_password=$AZURE_PASSWORD\n//$AZURE_URL/registry/:email=$AZURE_EMAIL\n//$AZURE_URL/:username=$AZURE_USER\n//$AZURE_URL/:_password=$AZURE_PASSWORD\n//$AZURE_URL/:email=$AZURE_EMAIL\n; end auth token" > $HOME/.npmrc

echo "# Fim!"
