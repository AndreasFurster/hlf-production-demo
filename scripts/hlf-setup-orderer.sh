YELLOW='\033[0;33m' 
NO_COLOR='\033[0m'

export FABRIC_CFG_PATH=${PWD}
# export FABRIC_LOGGING_SPEC="WARN:cauthdsl=debug:policies=debug:msp=debug"


function printSeparator() {
  echo -e "${YELLOW}"
  echo -e "▶ $1 ${NO_COLOR}"
}

printSeparator "Generate crypto-material"
cryptogen generate --config=./crypto-config-daisycon.yaml --output=./generated/crypto-material
# cryptogen generate --config=./crypto-config-coolblue.yaml --output=./generated/crypto-material
# cryptogen generate --config=./crypto-config-tweakers.yaml --output=./generated/crypto-material


printSeparator "Create Genesis-Block"
configtxgen \
  -profile ApNetworkProfile \
  -configPath ${PWD} \
  -channelID system-channel \
  -outputBlock ./generated/system-genesis-block/genesis.block

printSeparator "Start node"

docker-compose --file ./docker-compose-node.yaml down --volumes --remove-orphans
sleep 2
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

printSeparator "Create Anchor Peers Update for Tweakers"
configtxgen \
  -profile ApChannelProfile \
  -configPath ${PWD} \
  -outputAnchorPeersUpdate ./generated/channel-artifacts/TweakersMSPanchors.tx \
  -channelID apchannel \
  -asOrg Tweakers
