#!/bin/bash

# Auto Install Ethereum Sepolia Node RPC

echo "🚀 Memulai setup node Ethereum Sepolia RPC..."

# Update & install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y software-properties-common curl

# Tambahkan PPA Ethereum dan install Geth
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt update
sudo apt install -y geth

# Buat direktori data
mkdir -p /root/.ethereum/sepolia

# Buat service systemd untuk Sepolia node
cat <<EOF | sudo tee /etc/systemd/system/geth-sepolia.service
[Unit]
Description=Ethereum Sepolia Node
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/bin/geth --sepolia \\
  --http --http.addr 0.0.0.0 --http.port 8545 \\
  --http.api eth,net,web3 \\
  --http.corsdomain "*" \\
  --syncmode snap \\
  --datadir /root/.ethereum/sepolia

Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

# Reload systemd & enable service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable geth-sepolia
sudo systemctl start geth-sepolia

echo "✅ Geth Sepolia Node sedang berjalan sebagai service systemd"
echo "⏳ Tunggu sinkronisasi selesai. Cek dengan: journalctl -u geth-sepolia -f"
echo "🌐 Akses RPC endpoint di: http://$(curl -s ifconfig.me):8545"
