. ./utils.sh

#== 1 Create coolblue peer with crypto material ==
asCoolblue

# Upload config files
uploadFile ./config/crypto-config-coolblue.yaml crypto-config.yaml
uploadFile ./config/docker-compose-coolblue.yaml docker-compose-node.yaml

# Generate crypto material & start container
executeScript ./scripts/hlf-start-peer.sh

# mkdir -p ./temp/coolblue/msp 
# downloadFolder generated/crypto-material/peerOrganizations/coolblue.sbc.andreasfurster.nl/msp ./temp/coolblue

# == 2 Create tweakers peer with crypto material ==
asTweakers

# Upload config files
uploadFile ./config/crypto-config-tweakers.yaml crypto-config.yaml
uploadFile ./config/docker-compose-tweakers.yaml docker-compose-node.yaml

# Generate crypto material & start container
executeScript ./scripts/hlf-start-peer.sh

# mkdir -p ./temp/tweakers/msp
# downloadFolder generated/crypto-material/peerOrganizations/tweakers.sbc.andreasfurster.nl/msp ./temp/tweakers

# == 2 Create orderer & allow peers ==
asDaisycon

# Create some folders to store crypto things
executeScript ./scripts/hlf-prepare-orderer.sh

# Upload config files
uploadFile ./config/core.yaml core.yaml 
uploadFile ./config/configtx.yaml configtx.yaml 
uploadFile ./config/crypto-config-daisycon.yaml crypto-config-daisycon.yaml
uploadFile ./config/docker-compose-daisycon.yaml docker-compose-node.yaml

uploadFile ./config/crypto-config-tweakers.yaml crypto-config-tweakers.yaml
uploadFile ./config/crypto-config-coolblue.yaml crypto-config-coolblue.yaml

# upload msps from peers
# uploadFolder ./temp/coolblue/msp generated/crypto-material/peerOrganizations/coolblue.sbc.andreasfurster.nl
# uploadFolder ./temp/tweakers/msp generated/crypto-material/peerOrganizations/tweakers.sbc.andreasfurster.nl

# Generate crypto material, start orderer, generate genesis, generate channel transaction
executeScript ./scripts/hlf-setup-orderer.sh

downloadFile generated/channel-artifacts/apchannel.tx ./temp/apchannel.tx
downloadFile generated/channel-artifacts/CoolblueMSPanchors.tx ./temp/coolblue/anchor.tx
downloadFile generated/channel-artifacts/TweakersMSPanchors.tx ./temp/tweakers/anchor.tx
downloadFile generated/crypto-material/ordererOrganizations/daisycon.sbc.andreasfurster.nl/tlsca/tlsca.daisycon.sbc.andreasfurster.nl-cert.pem ./temp/tlsca.daisycon.sbc.andreasfurster.nl-cert.pem

# Download peer crypto material
downloadFolder generated/crypto-material/peerOrganizations ./temp

# == 3 Join channel & orderer ==
asCoolblue

uploadFile ./config/core.yaml core.yaml 
uploadFile ./temp/tlsca.daisycon.sbc.andreasfurster.nl-cert.pem generated/crypto-material/ordererOrganizations/daisycon.sbc.andreasfurster.nl/tlsca/tlsca.daisycon.sbc.andreasfurster.nl-cert.pem
uploadFolder ./temp/peerOrganizations/coolblue.sbc.andreasfurster.nl generated/crypto-material/peerOrganizations

# Upload transactions
uploadFile ./temp/apchannel.tx apchannel.tx 
uploadFile ./temp/coolblue/anchor.tx anchor.tx

# Configure peer as anchor, join channel
executeScript ./scripts/hlf-register-peer.sh

