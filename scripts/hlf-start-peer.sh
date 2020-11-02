echo "Generate crypto-material"
cryptogen generate --config=./crypto-config.yaml --output=./generated/crypto-material

echo "Start node"
docker-compose --file ./docker-compose-node.yaml up -d