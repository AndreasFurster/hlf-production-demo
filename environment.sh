function asDaisycon() {
  printSeparator "Switched to Daisycon"
  export PEER_IP=$(< ./outputs/daisycon_ip.txt)
  export PEER_PRIVATE_KEY_FILE=./outputs/daisycon_private_key.pem
}

function asTweakers() {
  printSeparator "Switched to Tweakers"
  export PEER_IP=$(< ./outputs/tweakers_ip.txt)
  export PEER_PRIVATE_KEY_FILE=./outputs/tweakers_private_key.pem
}

function asCoolblue() {
  printSeparator "Switched to Coolblue"
  export PEER_IP=$(< ./outputs/coolblue_ip.txt)
  export PEER_PRIVATE_KEY_FILE=./outputs/coolblue_private_key.pem
}
