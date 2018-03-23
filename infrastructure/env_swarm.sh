#!/usr/bin/env bash
manager_ip="$(terraform output -json | jq -r ".[\"manager_ip\"].value")"
echo "export DOCKER_TLS_VERIFY=\"1\""
echo "export DOCKER_HOST=\"tcp://$manager_ip:2376\""
echo "export DOCKER_CERT_PATH=\"~/.ssh\""
# Run this command to configure your shell:
# eval $(env_swarm.sh)