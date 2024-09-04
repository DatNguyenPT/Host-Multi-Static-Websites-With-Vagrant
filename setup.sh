#!/bin/bash

# Create log file
echo "##############################################"
echo "Creating log file"

if [ ! -d /etc/log ]; then
    sudo mkdir -p /etc/log
fi

sudo touch /etc/log/errorlog.txt
filedir="/etc/log/errorlog.txt"

echo "##############################################"

# Install packages
echo "##############################################"
echo "Installing packages"
sudo apt-get update
sudo apt-get install apache2 -y

echo "##############################################"

# Enable and start service
echo "##############################################"
echo "Starting service"
sudo systemctl start apache2 > >(tee -a $filedir) 2>&1
sudo systemctl enable apache2 >> $filedir 2>&1

if [ $? -eq 0 ]; then
    echo "Apache service has been started"
    sudo systemctl status apache2
else
    echo "Apache service cannot be started"
    echo "Error detail:"
    cat $filedir
fi

echo "##############################################"

# Deploy static website
echo "##############################################"
echo "Downloading static website....."

url1="https://www.tooplate.com/zip-templates/2137_barista_cafe.zip"
url2="https://www.tooplate.com/zip-templates/2135_mini_finance.zip"
url3="https://www.tooplate.com/zip-templates/2134_gotto_job.zip"

user=$(cat /etc/hostname)
url=""

if [ "$user" == "web01" ]; then
    url=$url1
elif [ "$user" == "web02" ]; then 
    url=$url2
else
    url=$url3
fi

# Extract the file name from the URL
filename=$(basename "$url")

# Remove .zip extension from filename
basename_no_ext="${filename%.zip}"

if [ ! -d /etc/websitedownload ]; then
    sudo mkdir -p /etc/websitedownload
fi

cd /etc/websitedownload

# Download the file
sudo wget "$url"

# Install unzip
sudo apt-get install unzip -y

echo "Downloaded file name is: $filename"

# Unzip and deploy the website

if [ ! -d /etc/website ]; then
    sudo mkdir -p /etc/website
fi

sudo unzip /etc/websitedownload/$filename -d /etc/website

echo "Deploying static website....."

sudo rm -rf /var/www/html/index.html
sudo cp -r /etc/website/$basename_no_ext/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Reload Apache to apply changes
sudo systemctl restart apache2

# Display IP address
ip=$(ip -4 addr show | grep "enp0s8" | awk '{print $2}' | cut -d/ -f1)
echo "Access http://${ip} to view the website"

echo "##############################################"
