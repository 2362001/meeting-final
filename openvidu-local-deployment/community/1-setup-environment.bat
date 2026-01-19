set NETWORK_NAME=openvidu-community

docker network create %NETWORK_NAME% 2>nul
docker volume create openvidu-redis
docker volume create openvidu-minio-data
docker volume create openvidu-minio-certs
docker volume create openvidu-mongo-data
docker volume create openvidu-egress-data
docker volume create openvidu-agents-config

docker run --rm ^
  --name setup ^
  --network %NETWORK_NAME% ^
  -v openvidu-minio-data:/minio ^
  -v openvidu-mongo-data:/mongo ^
  -v openvidu-egress-data:/egress ^
  -v "%~dp0scripts\setup.sh:/scripts/setup.sh:ro" ^
  -e USE_HTTPS=false ^
  -e LAN_MODE=false ^
  -e RUN_WITH_SCRIPT=false ^
  --user root ^
  docker.io/busybox:1.37.0 ^
  /bin/sh /scripts/setup.sh

pause
