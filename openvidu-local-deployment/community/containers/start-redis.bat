@echo off
docker run --rm ^
  --name redis ^
  --add-host host.docker.internal:host-gateway ^
  -p 6379:6379 ^
  docker.io/redis:8.2.2-alpine ^
  redis-server --bind 0.0.0.0 --requirepass redis_password_123
