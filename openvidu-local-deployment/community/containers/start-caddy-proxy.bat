@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community

docker run --rm ^
  --name caddy-proxy ^
  --network openvidu-community ^
  --add-host host.docker.internal:host-gateway ^
  -p 5443:5443 ^
  -p 6443:6443 ^
  -p 7443:7443 ^
  -p 7880:7880 ^
  -p 9443:9443 ^
  -v "%~dp0..\custom-layout:/var/www/custom-layout:ro" ^
  -e LAN_DOMAIN= ^
  -e LAN_PRIVATE_IP= ^
  -e LAN_MODE=false ^
  -e USE_HTTPS=false ^
  -e LIVEKIT_API_KEY=devkey ^
  -e LIVEKIT_API_SECRET=secret ^
  -e DASHBOARD_ADMIN_USERNAME=admin ^
  -e DASHBOARD_ADMIN_PASSWORD=admin ^
  -e MINIO_ACCESS_KEY=minioadmin ^
  -e MINIO_SECRET_KEY=minioadmin_password_123 ^
  -e MEET_INITIAL_ADMIN_USER=admin ^
  -e MEET_INITIAL_ADMIN_PASSWORD=admin ^
  -e MEET_INITIAL_API_KEY=meet-api-key ^
  docker.io/openvidu/openvidu-caddy-local:3.5.0
