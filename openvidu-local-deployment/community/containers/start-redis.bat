@echo off
REM Tắt hiển thị các dòng lệnh thực thi, chỉ hiển thị kết quả đầu ra
setlocal enabledelayedexpansion
REM Kích hoạt Delayed Expansion để lấy giá trị biến chính xác trong khối lệnh IF/FOR
chcp 65001 >nul
REM Chuyển bảng mã CMD sang UTF-8 để hiển thị tiếng Việt

echo ============================================
echo KHỞI ĐỘNG REDIS (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT Redis.
echo.

REM Load cấu hình (mật khẩu, tên network...) từ file config.bat ở thư mục cha
call "%~dp0..\config.bat"

echo [1/2] Kiểm tra Docker Network...
REM Kiểm tra sự tồn tại của network chung cho hệ thống
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

REM Chạy Docker Container:
REM --rm: Tự động xóa container khi cửa sổ này bị đóng
REM --name redis: Đặt tên cho container để các ứng dụng khác kết nối tới
REM --network: Gắn container vào mạng ảo chung
REM -p 6379:6379: Ánh xạ cổng từ máy thật vào container
REM redis-server...: Lệnh khởi động server kèm cấu hình mật khẩu
docker run --rm ^
  --name redis ^
  --network %NETWORK_NAME% ^
  -p 6379:6379 ^
  docker.io/redis:8.2.2-alpine ^
  redis-server --bind 0.0.0.0 --requirepass %REDIS_PASSWORD%

echo.
echo ✓ Container Redis đã dừng.
pause
REM Giữ cửa sổ lại để xem thông báo trước khi đóng hẳn
