@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG REDIS (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT Redis.
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

echo [1/2] Kiểm tra Docker Network...
docker network inspect %NETWORK_NAME% >nul 2>&1
if !errorlevel! neq 0 (
    docker network create %NETWORK_NAME%
    echo ✓ Đã tạo network %NETWORK_NAME%.
)

echo [2/2] Đang khởi chạy Redis...
echo --------------------------------------------
echo 📊 Thông tin truy cập:
echo    Host: localhost
echo    Port: 6379
echo    Pass: %REDIS_PASSWORD%
echo --------------------------------------------
echo ĐANG HIỂN THỊ LOGS TRỰC TIẾP:
echo.

REM Chạy container ở chế độ foreground (không có -d)
REM --rm: Tự động xóa container khi dừng
REM --name redis: Đặt tên để các container khác tìm thấy
docker run --rm ^
  --name redis ^
  --network %NETWORK_NAME% ^
  -p 6379:6379 ^
  docker.io/redis:8.2.2-alpine ^
  redis-server --bind 0.0.0.0 --requirepass %REDIS_PASSWORD%

echo.
echo ✓ Container Redis đã dừng.
pause
