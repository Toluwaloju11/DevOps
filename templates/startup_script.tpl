#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo apt-get update
sudo apt-get install apache2
sudo systemctl start apache2
sudo systemctl status apache2