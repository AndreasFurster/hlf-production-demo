YELLOW='\033[0;33m' 
NO_COLOR='\033[0m'

export FABRIC_CFG_PATH=${PWD}

function printSeparator() {
  echo -e "${YELLOW}"
  echo -e "▶ $1 ${NO_COLOR}"
}

printSeparator "Generate crypto-material"
cryptogen generate --config=./crypto-config.yaml --output=./generated/crypto-material

printSeparator "Create Genesis-Block"
configtxgen \
  -profile ApNetworkProfile \
  -configPath ${PWD} \
  -channelID system-channel \
  -outputBlock ./generated/system-genesis-block/genesis.block

printSeparator "Start node"
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

docker-compose --file ./docker-compose-node.yaml up -d

printSeparator "Create Channel Transaction"
configtxgen \
  -profile ApChannelProfile \
  -configPath ${PWD} \
  -outputCreateChannelTx ./generated/channel-artifacts/apchannel.tx \
  -channelID apchannel

printSeparator "Create Anchor Peers Update for Coolblue"
configtxgen \
  -profile ApChannelProfile \
  -configPath ${PWD} \
  -outputAnchorPeersUpdate ./generated/channel-artifacts/CoolblueMSPanchors.tx \
  -channelID apchannel \
  -asOrg Coolblue

