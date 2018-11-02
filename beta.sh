#!/bin/bash

set -e

ACTION=${1:-plan}

terraform $ACTION \
    -auto-approve \
    -var "do_token=${DO_TOKEN}" \
    -var "pub_key=$HOME/.ssh/holmescode_rsa.pub" \
    -var "pvt_key=$HOME/.ssh/holmescode_rsa" \
    -var "ssh_fingerprint=40:7c:f3:3b:97:91:89:33:7f:a8:77:0e:d3:83:77:f9"
