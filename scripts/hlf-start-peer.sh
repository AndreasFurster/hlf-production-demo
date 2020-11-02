
echo "Generate crypto-material"
cryptogen generate --config=./crypto-config.yaml --output=./generated/crypto-material

echo "Stop old containers"
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

echo "Start container"
docker-compose --file ./docker-compose-node.yaml up -d

echo "Creating folders for crypto material from orderer"
mkdir -p generated/crypto-material/ordererOrganizations/daisycon.networks.sbc.andreasfurster.nl/tlsca