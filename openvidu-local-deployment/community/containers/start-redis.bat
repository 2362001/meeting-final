@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG REDIS
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

echo Đang kiểm tra container Redis...
docker ps -a --filter "name=redis" --format "{{.Names}}" | findstr /x "redis" >nul
if %errorlevel% equ 0 (
    echo Container Redis đã tồn tại. Đang khởi động lại...
    docker start redis
    if %errorlevel% equ 0 (
        echo ✓ Redis đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại Redis
        pause
        exit /b 1
    )
) else (
    echo Tạo container Redis mới...
    docker run -d ^
      --name redis ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      -p 6379:6379 ^
      -v openvidu-redis:/data ^
      docker.io/redis:8.2.2-alpine ^
      redis-server --bind 0.0.0.0 --requirepass %REDIS_PASSWORD%
    
    if %errorlevel% equ 0 (
        echo ✓ Redis đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động Redis
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin Redis:
echo    Port: 6379
echo    Password: %REDIS_PASSWORD%
echo.
echo Kiểm tra logs: docker logs redis
echo Dừng container: docker stop redis
echo.
pause
