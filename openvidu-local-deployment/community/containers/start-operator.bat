@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community
docker volume inspect openvidu-agents-config >nul 2>&1 || docker volume create openvidu-agents-config

docker run --rm ^
  --name operator ^
  --network openvidu-community ^
  -v /var/run/docker.sock:/var/run/docker.sock ^
  -v openvidu-agents-config:/agents-config ^
  -v "%~dp0..:/deployment:ro" ^
  -e MODE=agent-manager-local ^
  -e DEPLOYMENT_FILES_DIR=/deployment ^
  -e AGENTS_CONFIG_DIR=/agents-config ^
  -e NETWORK_NAME=openvidu-community ^
  -e AGENTS_CONFIG_VOLUME=openvidu-agents-config ^
  -e LIVEKIT_URL=ws://openvidu:7880/ ^
  -e LIVEKIT_API_KEY=devkey ^
  -e LIVEKIT_API_SECRET=secret ^
  -e REDIS_ADDRESS=redis:6379 ^
  -e REDIS_PASSWORD=redis_password_123 ^
  docker.io/openvidu/openvidu-operator:3.5.0
