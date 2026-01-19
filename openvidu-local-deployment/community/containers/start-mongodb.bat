@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community
docker volume inspect openvidu-mongo-data >nul 2>&1 || docker volume create openvidu-mongo-data

docker run --rm ^
  --name mongo ^
  --network openvidu-community ^
  -p 27017:27017 ^
  -v openvidu-mongo-data:/bitnami/mongodb ^
  -e MONGODB_ROOT_USER=admin ^
  -e MONGODB_ROOT_PASSWORD=mongo_password_123 ^
  -e MONGODB_ADVERTISED_HOSTNAME=mongo ^
  -e MONGODB_REPLICA_SET_MODE=primary ^
  -e MONGODB_REPLICA_SET_NAME=rs0 ^
  -e MONGODB_REPLICA_SET_KEY=devreplicasetkey ^
  docker.io/openvidu/mongodb:8.0.15-r0
