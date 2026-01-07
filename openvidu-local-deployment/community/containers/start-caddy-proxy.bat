@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG CADDY PROXY (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT Gateway (Caddy).
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"
set PARENT_DIR=%~dp0..

echo [1/2] Kiểm tra Docker Network...
docker network inspect %NETWORK_NAME% >nul 2>&1
if !errorlevel! neq 0 (
    docker network create %NETWORK_NAME%
)

echo [2/2] Đang khởi chạy Caddy Proxy...
echo --------------------------------------------
echo 🌍 ĐIỂM TRUY CẬP HỆ THỐNG:
echo    Dashboard:     http://localhost:7880/dashboard
echo    MinIO:         http://localhost:7880/minio-console
echo    WebRTC Webskt: ws://localhost:7880
echo --------------------------------------------
echo.

docker run --rm ^
  --name caddy-proxy ^
  --network %NETWORK_NAME% ^
  --add-host host.docker.internal:host-gateway ^
  -p 5443:5443 ^
  -p 6443:6443 ^
  -p 7443:7443 ^
  -p 7880:7880 ^
  -p 9443:9443 ^
  -v "%PARENT_DIR%\custom-layout:/var/www/custom-layout:ro" ^
  -e LAN_DOMAIN=%LAN_DOMAIN% ^
  -e LAN_PRIVATE_IP=%LAN_PRIVATE_IP% ^
  -e LAN_MODE=%LAN_MODE% ^
  -e USE_HTTPS=%USE_HTTPS% ^
  -e LIVEKIT_API_KEY=%LIVEKIT_API_KEY% ^
  -e LIVEKIT_API_SECRET=%LIVEKIT_API_SECRET% ^
  -e DASHBOARD_ADMIN_USERNAME=%DASHBOARD_ADMIN_USERNAME% ^
  -e DASHBOARD_ADMIN_PASSWORD=%DASHBOARD_ADMIN_PASSWORD% ^
  -e MINIO_ACCESS_KEY=%MINIO_ACCESS_KEY% ^
  -e MINIO_SECRET_KEY=%MINIO_SECRET_KEY% ^
  -e MEET_INITIAL_ADMIN_USER=%MEET_INITIAL_ADMIN_USER% ^
  -e MEET_INITIAL_ADMIN_PASSWORD=%MEET_INITIAL_ADMIN_PASSWORD% ^
  -e MEET_INITIAL_API_KEY=%MEET_INITIAL_API_KEY% ^
  docker.io/openvidu/openvidu-caddy-local:3.5.0

echo.
echo ✓ Container Caddy Proxy đã dừng.
pause
