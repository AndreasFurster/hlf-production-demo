
# echo "Generate crypto-material"
sudo rm -rf ./generated
docker-compose --file ./docker-compose-node.yaml down --volumes --remove-orphans
cryptogen generate --config=./crypto-config.yaml --output=./generated/crypto-material
# sleep 2

# echo "Start container"
# docker-compose --file ./docker-compose-node.yaml up -d

echo "Creating folders for crypto material from orderer"
mkdir -p generated/crypto-material/ordererOrganizations/daisycon.sbc.andreasfurster.nl/tlsca
mkdir -p generated/crypto-material/peerOrganizations