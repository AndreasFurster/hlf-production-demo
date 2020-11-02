YELLOW='\033[0;33m' 
NO_COLOR='\033[0m'

function printSeparator() {
  echo -e "${YELLOW}"
  echo -e "▶ $1 ${NO_COLOR}"
}

export FABRIC_CFG_PATH=${PWD}
export FABRIC_LOGGING_SPEC="WARN:cauthdsl=debug:policies=debug:msp=debug"

export ORDERER_CA=${PWD}/generated/crypto-material/ordererOrganizations/daisycon.sbc.andreasfurster.nl/tlsca/tlsca.daisycon.sbc.andreasfurster.nl-cert.pem
export CORE_PEER_LOCALMSPID=CoolblueMSP
export CORE_PEER_MSPCONFIGPATH=${PWD}/generated/crypto-material/peerOrganizations/coolblue.sbc.andreasfurster.nl/peers/peer0.coolblue.sbc.andreasfurster.nl/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/generated/crypto-material/peerOrganizations/coolblue.sbc.andreasfurster.nl/peers/peer0.coolblue.sbc.andreasfurster.nl/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7050

printSeparator "Create channel"
peer channel create \
  --channelID apchannel \
  --file ./apchannel.tx \
  --outputBlock ./apchannel.block \
  --orderer orderer0.daisycon.sbc.andreasfurster.nl:7050 \
  --tls false \
  --cafile $ORDERER_CA
  # --ordererTLSHostnameOverride orderer0.ap.com \

printSeparator "Join Org1 to channel"
# peer channel join \
#   --blockpath ./apchannel.block 

sleep 1

# printSeparator "Update Anchor Peers as Org1"
# peer channel update \
#   --channelID apchannel \
#   --file ./generated/channel-artifacts/Org1MSPanchors.tx \
#   --orderer localhost:7050 \
#   --ordererTLSHostnameOverride orderer0.ap.com \
#   --tls $CORE_PEER_TLS_ENABLED \
#   --cafile $ORDERER_CA