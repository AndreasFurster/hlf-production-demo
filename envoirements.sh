function asCoolblue() {
  printSeparator "Switched to Coolblue"
  export PEER_IP=$(< ./outputs/coolblue_ip.txt)
  export PEER_PRIVATE_KEY_FILE=./outputs/coolblue_private_key.pem
}

function asDaisycon() {
  printSeparator "Switched to Daisycon"
  export PEER_IP=$(< ./outputs/daisycon_ip.txt)
  export PEER_PRIVATE_KEY_FILE=./outputs/daisycon_private_key.pem
}