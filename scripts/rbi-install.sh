#!/bin/bash

sudo yum update -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo wget https://github.com$(curl -s https://github.com/docker/compose/releases | grep docker-compose-Linux-x86_64 | head -1 | cut -d '"' -f2) -O /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo fallocate -l 1g /mnt/1GiB.swap
sudo chmod 600 /mnt/1GiB.swap
sudo mkswap /mnt/1GiB.swap
sudo swapon /mnt/1GiB.swap
echo '/mnt/1GiB.swap swap swap defaults 0 0' | sudo tee -a /etc/fstab
wget $(curl -s https://www.kasmweb.com/downloads.html |grep kasm-static | head -1 | cut -d '"' -f4) -O /tmp/kasm.tgz
cd /tmp
tar xf kasm.tgz
echo "y" | sudo bash kasm_release/install.sh | sudo tee /root/kasm_install.txt
cat << 'EOF' > /home/student/nginx.conf
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  20000;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
EOF
cat << 'EOF' > /home/student/default.conf
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;
    location / {
        proxy_pass https://kasm_proxy/;
        proxy_ssl_verify       off;
    }
}
EOF
sudo docker run -dit --restart always --name bandaid -p "80:80" -v "/home/student/default.conf:/etc/nginx/conf.d/default.conf" -v "/home/student/nginx.conf:/etc/nginx/nginx.conf" --network kasm_default_network nginx:alpine
