@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG MONGODB (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT MongoDB.
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

echo [1/3] Kiểm tra Docker Network...
docker network inspect %NETWORK_NAME% >nul 2>&1
if !errorlevel! neq 0 (
    docker network create %NETWORK_NAME%
    echo ✓ Đã tạo network %NETWORK_NAME%.
)

echo [2/3] Kiểm tra Docker Volume...
docker volume inspect openvidu-mongo-data >nul 2>&1
if !errorlevel! neq 0 (
    docker volume create openvidu-mongo-data
    echo ✓ Đã tạo volume lưu trữ dữ liệu.
)

echo [3/3] Đang khởi chạy MongoDB...
echo --------------------------------------------
echo 📊 Thông tin truy cập:
echo    Host: localhost
echo    Port: 27017
echo    User: %MONGO_ADMIN_USERNAME%
echo    Pass: %MONGO_ADMIN_PASSWORD%
echo --------------------------------------------
echo ĐANG HIỂN THỊ LOGS TRỰC TIẾP:
echo.

docker run --rm ^
  --name mongo ^
  --network %NETWORK_NAME% ^
  -p 27017:27017 ^
  -v openvidu-mongo-data:/bitnami/mongodb ^
  -e MONGODB_ROOT_USER=%MONGO_ADMIN_USERNAME% ^
  -e MONGODB_ROOT_PASSWORD=%MONGO_ADMIN_PASSWORD% ^
  -e MONGODB_ADVERTISED_HOSTNAME=mongo ^
  -e MONGODB_REPLICA_SET_MODE=primary ^
  -e MONGODB_REPLICA_SET_NAME=rs0 ^
  -e MONGODB_REPLICA_SET_KEY=devreplicasetkey ^
  docker.io/openvidu/mongodb:8.0.15-r0

echo.
echo ✓ Container MongoDB đã dừng.
pause
