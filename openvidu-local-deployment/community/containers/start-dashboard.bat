@echo off
REM Tắt hiển thị các dòng kinh thực thi
setlocal enabledelayedexpansion
REM Kích hoạt Delayed Expansion để lấy giá trị biến chính xác trong khối lệnh IF/FOR
chcp 65001 >nul
REM Chuyển bảng mã CMD sang UTF-8

echo ============================================
echo KHỞI ĐỘNG DASHBOARD (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT Dashboard.
echo.

REM Load cấu hình từ file config.bat ở thư mục cha
call "%~dp0..\config.bat"

echo [1/1] Đang khởi chạy Dashboard...
echo --------------------------------------------
echo 📊 TRANG QUẢN TRỊ:
echo    URL: http://localhost:7880/dashboard (cần Caddy Proxy)
echo    User: %DASHBOARD_ADMIN_USERNAME%
echo    Pass: %DASHBOARD_ADMIN_PASSWORD%
echo --------------------------------------------
echo.

REM Chạy Docker Container:
REM Giao diện quản lý các Rooms, Sessions và xem Logs tập trung
docker run --rm ^
  --name dashboard ^
  --network %NETWORK_NAME% ^
  -e SERVER_PORT=5000 ^
  -e ADMIN_USERNAME=%DASHBOARD_ADMIN_USERNAME% ^
  -e ADMIN_PASSWORD=%DASHBOARD_ADMIN_PASSWORD% ^
  -e DATABASE_URL=mongodb://%MONGO_ADMIN_USERNAME%:%MONGO_ADMIN_PASSWORD%@mongo:27017/?replicaSet=rs0^&readPreference=primaryPreferred ^
  docker.io/openvidu/openvidu-dashboard:3.5.0

echo.
echo ✓ Container Dashboard đã dừng.
pause
