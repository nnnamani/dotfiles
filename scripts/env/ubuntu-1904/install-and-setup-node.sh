#!/bin/bash


# Install nodejs and setup environment for npm

# Install node, npm from apt
sudo apt install -y nodejs npm

# Install package manager 'n'
sudo npm install n -g

# Install latest node by 'n'
sudo n stable
