@echo off
docker run --rm ^
  --name dashboard ^
  --add-host host.docker.internal:host-gateway ^
  -e SERVER_PORT=5000 ^
  -e ADMIN_USERNAME=admin ^
  -e ADMIN_PASSWORD=admin ^
  -e DATABASE_URL=mongodb://admin:mongo_password_123@host.docker.internal:27017/?replicaSet=rs0^&readPreference=primaryPreferred ^
  docker.io/openvidu/openvidu-dashboard:3.5.0
