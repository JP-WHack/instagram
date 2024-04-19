sudo apt update
sudo apt-get update
sudo apt-get install git
sudo apt-get install wget
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
bash start.sh