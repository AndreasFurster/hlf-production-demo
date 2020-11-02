sudo rm -rf ./generated

echo "Creating folders for crypto material from orgs"
mkdir -p ./generated/crypto-material/peerOrganizations/coolblue.sbc.andreasfurster.nl/msp/admincerts
mkdir -p ./generated/crypto-material/peerOrganizations/coolblue.sbc.andreasfurster.nl/msp/cacerts
mkdir -p ./generated/crypto-material/peerOrganizations/coolblue.sbc.andreasfurster.nl/msp/tlscacerts
mkdir -p ./generated/crypto-material/peerOrganizations/tweakers.sbc.andreasfurster.nl/msp/admincerts
mkdir -p ./generated/crypto-material/peerOrganizations/tweakers.sbc.andreasfurster.nl/msp/cacerts
mkdir -p ./generated/crypto-material/peerOrganizations/tweakers.sbc.andreasfurster.nl/msp/tlscacerts
