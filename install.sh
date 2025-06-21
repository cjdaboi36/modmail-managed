#!/bin/sh

sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt -y install python3.10 python3.10-dev python3.10-venv python3-pip \
                    libcairo2-dev libffi-dev g++ \
                    git nano
python3.10 -m pip install pipenv
sudo apt install npm -y && sudo npm i pm2 -g
