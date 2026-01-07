@echo off
REM Tắt hiển thị các dòng kinh thực thi
setlocal enabledelayedexpansion
REM Kích hoạt Delayed Expansion để lấy giá trị biến chính xác trong khối lệnh IF/FOR
chcp 65001 >nul
REM Chuyển bảng mã CMD sang UTF-8

echo ============================================
echo KHỞI ĐỘNG MONGODB (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT MongoDB.
echo.

REM Load cấu hình (mật khẩu, tên network...) từ file config.bat ở thư mục cha
call "%~dp0..\config.bat"

echo [1/3] Kiểm tra Docker Network...
REM Kiểm tra sự tồn tại của network chung
docker network inspect %NETWORK_NAME% >nul 2>&1
if !errorlevel! neq 0 (
    docker network create %NETWORK_NAME%
    echo ✓ Đã tạo network %NETWORK_NAME%.
)

echo [2/3] Kiểm tra Docker Volume...
REM MongoDB cần Volume để không bị mất dữ liệu database khi container bị xóa (--rm)
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

REM Chạy Docker Container:
REM --rm: Tự động xóa container khi đóng CMD
REM --name mongo: Đặt tên định danh cho các service khác kết nối (Dashboard, Meet...)
REM -v ...:/bitnami/mongodb: Ánh xạ ổ đĩa ảo để giữ lại dữ liệu kể cả khi container bị xóa
REM -e MONGODB_REPLICA_SET_MODE=primary: Bắt buộc để sử dụng các tính năng cao cấp của OpenVidu
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
