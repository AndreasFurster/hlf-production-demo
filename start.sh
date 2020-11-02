. ./utils.sh

# == 1 ==
asCoolblue

# Upload config files
uploadFile ./config/crypto-config-coolblue.yaml crypto-config.yaml 
uploadFile ./config/docker-compose-coolblue.yaml docker-compose-node.yaml 

# Generate crypto material & start container
executeScript ./scripts/hlf-start-peer.sh

mkdir -p ./temp/coolblue/msp
downloadFolder generated/crypto-material/peerOrganizations/coolblue.advertisers.sbc.andreasfurster.nl/msp ./temp/coolblue

# == 2 ==
asDaisycon

# Generate crypto material & start container
executeScript ./scripts/hlf-prepare-orderer.sh

# Upload config files
uploadFile ./config/core.yaml core.yaml 
uploadFile ./config/configtx.yaml configtx.yaml 
uploadFile ./config/crypto-config-daisycon.yaml crypto-config.yaml 
uploadFile ./config/docker-compose-daisycon.yaml docker-compose-node.yaml

# upload msp from Coolblue
uploadFolder ./temp/coolblue/msp generated/crypto-material/peerOrganizations/coolblue.advertisers.sbc.andreasfurster.nl

# Generate crypto material & start container
executeScript ./scripts/hlf-start-orderer.sh




