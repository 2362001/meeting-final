@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG MINIO (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT MinIO.
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

echo [1/3] Kiểm tra Docker Network...
docker network inspect %NETWORK_NAME% >nul 2>&1
if !errorlevel! neq 0 (
    docker network create %NETWORK_NAME%
)

echo [2/3] Kiểm tra Docker Volumes...
docker volume inspect openvidu-minio-data >nul 2>&1 || docker volume create openvidu-minio-data
docker volume inspect openvidu-minio-certs >nul 2>&1 || docker volume create openvidu-minio-certs

echo [3/3] Đang khởi chạy MinIO...
echo --------------------------------------------
echo 📊 Thông tin truy cập:
echo    S3 API Port: 9000
echo    Console URL: http://localhost:7880/minio-console (cần Caddy)
echo    Access Key: %MINIO_ACCESS_KEY%
echo    Secret Key: %MINIO_SECRET_KEY%
echo --------------------------------------------
echo.

docker run --rm ^
  --name minio ^
  --network %NETWORK_NAME% ^
  -p 9000:9000 ^
  -v openvidu-minio-data:/bitnami/minio/data ^
  -v openvidu-minio-certs:/certs ^
  -e MINIO_ROOT_USER=%MINIO_ACCESS_KEY% ^
  -e MINIO_ROOT_PASSWORD=%MINIO_SECRET_KEY% ^
  -e MINIO_DEFAULT_BUCKETS=openvidu-appdata ^
  -e MINIO_CONSOLE_SUBPATH=/minio-console ^
  -e MINIO_BROWSER=on ^
  -e MINIO_BROWSER_REDIRECT_URL=http://localhost:7880/minio-console ^
  docker.io/openvidu/minio:2025.9.7-debian-12-r3

echo.
echo ✓ Container MinIO đã dừng.
pause
