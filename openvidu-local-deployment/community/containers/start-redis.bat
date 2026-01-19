@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community

docker run --rm ^
  --name redis ^
  --network openvidu-community ^
  -p 6379:6379 ^
  docker.io/redis:8.2.2-alpine ^
  redis-server --bind 0.0.0.0 --requirepass redis_password_123
