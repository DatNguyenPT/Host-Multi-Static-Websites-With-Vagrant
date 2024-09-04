#!/bin/bash

# Install necessary packages
echo "#################################"
echo "Installing packages"
echo "#################################"
sudo apt update || { echo "Failed to update package index"; exit 1; }
sudo apt install -y wget unzip apache2 || { echo "Failed to install packages"; exit 1; }
echo

# Start and enable apache2 service
echo "#################################"
echo "Start and Enable apache2 service"
echo "#################################"
sudo systemctl start apache2 || { echo "Failed to start apache2"; exit 1; }
sudo systemctl enable apache2 || { echo "Failed to enable apache2"; exit 1; }
echo

# Create directory to store web files
echo "#################################"
echo "Create directory to store web files"
echo "#################################"
mkdir -p /tmp/webfiles
cd /tmp/webfiles || { echo "Failed to change directory"; exit 1; }
echo

# Download and unzip the static website
echo "#################################"
echo "Download static website from tooplate.com"
echo "#################################"
wget https://www.tooplate.com/zip-templates/2098_health.zip -O 2098_health.zip || { echo "Failed to download file"; exit 1; }
unzip 2098_health.zip || { echo "Failed to unzip file"; exit 1; }
sudo cp -r 2098_health/* /var/www/html/ || { echo "Failed to copy files"; exit 1; }
echo

# Restart apache2 service
echo "#################################"
echo "Restart apache2 service"
echo "#################################"
sudo systemctl restart apache2 || { echo "Failed to restart apache2"; exit 1; }
echo

# Clean up
echo "#################################"
echo "Cleaning up..."
echo "#################################"
rm -rf /tmp/webfiles || { echo "Failed to clean up"; exit 1; }
echo

# Display apache2 status
echo "#################################"
echo "Apache2 Status: "
echo "#################################"
sudo systemctl status apache2 || { echo "Failed to get apache2 status"; exit 1; }
echo
