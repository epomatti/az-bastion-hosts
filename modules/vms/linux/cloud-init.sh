#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# Update
sudo apt update
sudo apt upgrade -y

