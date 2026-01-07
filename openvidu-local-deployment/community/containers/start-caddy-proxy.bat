@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG CADDY PROXY (Gateway)
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

set PARENT_DIR=%~dp0..

echo Đang kiểm tra container Caddy Proxy...
docker ps -a --filter "name=caddy-proxy" --format "{{.Names}}" | findstr /x "caddy-proxy" >nul
if %errorlevel% equ 0 (
    echo Container Caddy Proxy đã tồn tại. Đang khởi động lại...
    docker start caddy-proxy
    if %errorlevel% equ 0 (
        echo ✓ Caddy Proxy đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại Caddy Proxy
        pause
        exit /b 1
    )
) else (
    echo Tạo container Caddy Proxy mới...
    docker run -d ^
      --name caddy-proxy ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
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
    
    if %errorlevel% equ 0 (
        echo ✓ Caddy Proxy đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động Caddy Proxy
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin Caddy Proxy:
echo    Chức năng: Reverse Proxy, định tuyến requests
echo    Main Port: 7880
echo    Dashboard: http://localhost:7880/dashboard
echo    MinIO Console: http://localhost:7880/minio-console
echo.
echo Kiểm tra logs: docker logs caddy-proxy
echo Dừng container: docker stop caddy-proxy
echo.
pause
