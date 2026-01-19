@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community

docker run --rm ^
  --name egress ^
  --network openvidu-community ^
  --add-host host.docker.internal:host-gateway ^
  -v "%~dp0..\egress.yaml:/etc/egress.yaml:ro" ^
  -v openvidu-egress-data:/home/egress/tmp ^
  -e EGRESS_CONFIG_FILE=/etc/egress.yaml ^
  docker.io/openvidu/egress:3.5.0
