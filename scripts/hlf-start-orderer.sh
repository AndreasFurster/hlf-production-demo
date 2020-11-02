export FABRIC_CFG_PATH=${PWD}

echo "Generate crypto-material"
cryptogen generate --config=./crypto-config.yaml --output=./generated/crypto-material

echo "Create Genesis-Block"
configtxgen \
  -profile ApNetworkProfile \
  -configPath ${PWD} \
  -channelID system-channel \
  -outputBlock ./generated/system-genesis-block/genesis.block

echo "Start node"
docker-compose --file ./docker-compose-node.yaml up -d