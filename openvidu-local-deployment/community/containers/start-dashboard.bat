@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community

docker run --rm ^
  --name dashboard ^
  --network openvidu-community ^
  -e SERVER_PORT=5000 ^
  -e ADMIN_USERNAME=admin ^
  -e ADMIN_PASSWORD=admin ^
  -e DATABASE_URL=mongodb://admin:mongo_password_123@mongo:27017/?replicaSet=rs0^&readPreference=primaryPreferred ^
  docker.io/openvidu/openvidu-dashboard:3.5.0
