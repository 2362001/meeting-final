@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG MONGODB
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

echo Đang kiểm tra container MongoDB...
docker ps -a --filter "name=mongo" --format "{{.Names}}" | findstr /x "mongo" >nul
if %errorlevel% equ 0 (
    echo Container MongoDB đã tồn tại. Đang khởi động lại...
    docker start mongo
    if %errorlevel% equ 0 (
        echo ✓ MongoDB đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại MongoDB
        pause
        exit /b 1
    )
) else (
    echo Tạo container MongoDB mới...
    docker run -d ^
      --name mongo ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      -p 27017:27017 ^
      -v openvidu-mongo-data:/bitnami/mongodb ^
      -e MONGODB_ROOT_USER=%MONGO_ADMIN_USERNAME% ^
      -e MONGODB_ROOT_PASSWORD=%MONGO_ADMIN_PASSWORD% ^
      -e MONGODB_ADVERTISED_HOSTNAME=mongo ^
      -e MONGODB_REPLICA_SET_MODE=primary ^
      -e MONGODB_REPLICA_SET_NAME=rs0 ^
      -e MONGODB_REPLICA_SET_KEY=devreplicasetkey ^
      docker.io/openvidu/mongodb:8.0.15-r0
    
    if %errorlevel% equ 0 (
        echo ✓ MongoDB đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động MongoDB
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin MongoDB:
echo    Port: 27017
echo    Username: %MONGO_ADMIN_USERNAME%
echo    Password: %MONGO_ADMIN_PASSWORD%
echo    Replica Set: rs0
echo.
echo Kiểm tra logs: docker logs mongo
echo Dừng container: docker stop mongo
echo.
pause
