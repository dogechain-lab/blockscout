#!/bin/bash

# Usage: $0 network alert_receiver_url
# Simple alert from some webhook url would do this job.
# curl and jq must be installed.

NETWORK=$1
RECEIVER_URL=$2

HOSTNAME=$((hostname))
IP=$((hostname -i))

HOST="http://127.0.0.1:4000"
PROJECT_NAME="DogeChain"
PROGRAM_NAME="blockscout"

SLEEP_MINUTE=1

generate_post_data()
{
  local now=$(date +%F'T'%T'Z')
  eval local content="$1"
  cat <<EOT
{
  "msgtype": "text",
  "text": {
    "content": "$PROJECT_NAME(network: $NETWORK)\n$content\ntimestamp: $now"
  }
}
EOT
}

post_alarm() {
  curl $RECEIVER_URL \
    -H "Content-Type: application/json" \
    -d "${1}"
}

query_current_block() {
  local ret=$(curl -H "content-type: application/json" -X POST -d '{"id":0,"jsonrpc":"2.0","method":"eth_blockNumber","params":[]}' "$HOST/api/eth-rpc" | jq -r .result)
  echo $ret
}

# query block num
block1=$(query_current_block)

# take a little break for increasement
sleep $((SLEEP_MINUTE*60))

# query another block num
block2=$(query_current_block)

if [[ "$block1" -eq "$block2" ]]; then
  content="block stop upgrading after $(echo $((block1)))"
  post_alarm "$(generate_post_data \${content})"
fi