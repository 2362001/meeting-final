@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community
docker volume inspect openvidu-minio-data >nul 2>&1 || docker volume create openvidu-minio-data
docker volume inspect openvidu-minio-certs >nul 2>&1 || docker volume create openvidu-minio-certs

docker run --rm ^
  --name minio ^
  --network openvidu-community ^
  -p 9000:9000 ^
  -v openvidu-minio-data:/bitnami/minio/data ^
  -v openvidu-minio-certs:/certs ^
  -e MINIO_ROOT_USER=minioadmin ^
  -e MINIO_ROOT_PASSWORD=minioadmin_password_123 ^
  -e MINIO_DEFAULT_BUCKETS=openvidu-appdata ^
  -e MINIO_CONSOLE_SUBPATH=/minio-console ^
  -e MINIO_BROWSER=on ^
  -e MINIO_BROWSER_REDIRECT_URL=http://localhost:7880/minio-console ^
  docker.io/openvidu/minio:2025.9.7-debian-12-r3
