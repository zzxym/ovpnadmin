#!/usr/bin/env bash

read -p "Please selete IP version (4/6): " ip_version

if [ "$ip_version" = "4" ]; then
    external_ip=$(curl -s https://ipinfo.io/ip)
elif [ "$ip_version" = "6" ]; then
    external_ip=$(curl -s https://ifconfig.co/ip)
else
    echo "please input 4 or 6 "
    exit 1
fi

echo "Your external IP is: $external_ip"

read -p "Is this IP Right (y/n): " answer

if [ "$answer" != "y" ]; then
    read -p "Please input your IP or domain: " external_ip
fi

echo "your IP is : $external_ip"

cp docker-compose.yaml docker-compose.yaml.bak

sed -i "s/127.0.0.1/$external_ip/g" docker-compose.yaml

sed "s/127.0.0.1/$external_ip/g" docker-compose-slave.yaml

docker-compose -p openvpn-master up -d --build
