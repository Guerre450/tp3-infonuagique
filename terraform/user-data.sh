#!/bin/bash
# Add Docker's official GPG key:
# Rajoute les clés GPG officiel Docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
# Rajoute le répertoire APT.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#install Docker
#installe Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#initiation of the project and docker
#initiation du projet & docker
sudo git clone https://github.com/Guerre450/tp3-infonuagique.git
sudo chown ubuntu:ubuntu tp3-infonuagique
cd tp3-infonuagique
{
        echo 'MY_DOMAIN=${MY_DOMAIN}.duckdns.org'
        echo 'ENTRYPOINT=${ENTRYPOINT}'
        echo 'DUCKDNS_TOKEN=${DUCKDNS_TOKEN}'
} >> .env
sudo docker compose up -d
#assigning ip address to duckduckdns
#assignation d'address publique a duckduckdns
MY_IP=$(curl http://wtfismyip.com/text)
echo "MY PUB_IP: "
echo $MY_IP
curl -fsSL "https://www.duckdns.org/update?domains=${MY_DOMAIN}&token=${DUCKDNS_TOKEN}&verbose=true&ip=$${MY_IP}"