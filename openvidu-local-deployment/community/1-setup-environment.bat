@echo off
chcp 65001 >nul
echo ============================================
echo THIẾT LẬP MÔI TRƯỜNG OPENVIDU
echo ============================================
echo.

REM Load cấu hình
call "%~dp0config.bat"

echo [BƯỚC 1] Tạo Docker Network...
docker network create %NETWORK_NAME% 2>nul
if %errorlevel% equ 0 (
    echo ✓ Đã tạo network: %NETWORK_NAME%
) else (
    echo ℹ Network đã tồn tại hoặc có lỗi
)
echo.

echo [BƯỚC 2] Tạo Docker Volumes...
docker volume create openvidu-redis
docker volume create openvidu-minio-data
docker volume create openvidu-minio-certs
docker volume create openvidu-mongo-data
docker volume create openvidu-egress-data
docker volume create openvidu-agents-config
echo ✓ Đã tạo tất cả volumes
echo.

echo [BƯỚC 3] Chạy Setup Container (khởi tạo permissions)...
docker run --rm ^
  --name setup ^
  --network %NETWORK_NAME% ^
  -v openvidu-minio-data:/minio ^
  -v openvidu-mongo-data:/mongo ^
  -v openvidu-egress-data:/egress ^
  -v "%CURRENT_DIR%scripts\setup.sh:/scripts/setup.sh:ro" ^
  -e USE_HTTPS=%USE_HTTPS% ^
  -e LAN_MODE=%LAN_MODE% ^
  -e RUN_WITH_SCRIPT=false ^
  --user root ^
  docker.io/busybox:1.37.0 ^
  /bin/sh /scripts/setup.sh

if %errorlevel% equ 0 (
    echo ✓ Setup hoàn tất!
) else (
    echo ✗ Setup thất bại! Kiểm tra lỗi ở trên.
    pause
    exit /b 1
)
echo.

echo ============================================
echo ✓ THIẾT LẬP HOÀN TẤT!
echo ============================================
echo Bây giờ bạn có thể chạy file: 2-start-openvidu.bat
echo.
pause
