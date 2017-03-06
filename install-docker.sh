#!/bin/bash

# Install Dependencies

sudo apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl

if ! hash docker 2>/dev/null; then
    # Install Docker

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) \
         stable"

    sudo apt-get update

    sudo apt-get -y install docker-ce
fi

if ! hash docker-compose 2>/dev/null; then
    # Install Docker Compose

    sudo curl -o /usr/local/bin/docker-compose -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-`uname -s`-`uname -m`
    sudo chmod +x /usr/local/bin/docker-compose
fi
