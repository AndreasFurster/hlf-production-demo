#!/bin/bash

. ./environment.sh

GREEN='\033[0;32m' 
NO_COLOR='\033[0m'


function uploadFile() {
  printSeparator "Uploading file: /home/vmadmin/$2"
  scp -p -oStrictHostKeyChecking=no -i $PEER_PRIVATE_KEY_FILE $1 vmadmin@$PEER_IP:/home/vmadmin/$2
}

function uploadFolder() {
  printSeparator "Uploading folder: /home/vmadmin/$2"
  scp -rp -oStrictHostKeyChecking=no -i $PEER_PRIVATE_KEY_FILE $1 vmadmin@$PEER_IP:/home/vmadmin/$2
}

function downloadFile() {
  scp -p -oStrictHostKeyChecking=no -i $PEER_PRIVATE_KEY_FILE vmadmin@$PEER_IP:/home/vmadmin/$1 $2
}

function downloadFolder() {
  scp -rp -oStrictHostKeyChecking=no -i $PEER_PRIVATE_KEY_FILE vmadmin@$PEER_IP:/home/vmadmin/$1 $2
}

function executeScript() {
  printSeparator "Executing script: $1"
  ssh -oStrictHostKeyChecking=no -i $PEER_PRIVATE_KEY_FILE vmadmin@$PEER_IP 'bash -s' < $1
  printSeparator "Finished executing script: $1"
}

function openShell() {
  printSeparator "Opening shell"
  ssh -oStrictHostKeyChecking=no -i $PEER_PRIVATE_KEY_FILE vmadmin@$PEER_IP
}

function printSeparator() {
    echo -e "${GREEN}"
    echo -e "▶ $1 ${NO_COLOR}"
}