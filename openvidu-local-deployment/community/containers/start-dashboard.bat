@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG DASHBOARD
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

echo Đang kiểm tra container Dashboard...
docker ps -a --filter "name=dashboard" --format "{{.Names}}" | findstr /x "dashboard" >nul
if %errorlevel% equ 0 (
    echo Container Dashboard đã tồn tại. Đang khởi động lại...
    docker start dashboard
    if %errorlevel% equ 0 (
        echo ✓ Dashboard đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại Dashboard
        pause
        exit /b 1
    )
) else (
    echo Tạo container Dashboard mới...
    docker run -d ^
      --name dashboard ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      -e SERVER_PORT=5000 ^
      -e ADMIN_USERNAME=%DASHBOARD_ADMIN_USERNAME% ^
      -e ADMIN_PASSWORD=%DASHBOARD_ADMIN_PASSWORD% ^
      -e DATABASE_URL=mongodb://%MONGO_ADMIN_USERNAME%:%MONGO_ADMIN_PASSWORD%@mongo:27017/?replicaSet=rs0^&readPreference=primaryPreferred ^
      docker.io/openvidu/openvidu-dashboard:3.5.0
    
    if %errorlevel% equ 0 (
        echo ✓ Dashboard đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động Dashboard
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin Dashboard:
echo    URL: http://localhost:7880/dashboard
echo    Username: %DASHBOARD_ADMIN_USERNAME%
echo    Password: %DASHBOARD_ADMIN_PASSWORD%
echo.
echo ⚠️  Lưu ý: Cần khởi động Caddy Proxy để truy cập Dashboard
echo.
echo Kiểm tra logs: docker logs dashboard
echo Dừng container: docker stop dashboard
echo.
pause
