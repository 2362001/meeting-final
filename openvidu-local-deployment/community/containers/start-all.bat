@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG TẤT CẢ CONTAINERS (THEO THỨ TỰ)
echo ============================================
echo.

set CONTAINER_DIR=%~dp0

echo Bắt đầu khởi động tất cả containers theo thứ tự phụ thuộc...
echo.

echo ============================================
echo BƯỚC 1: KHỞI ĐỘNG CƠ SỞ DỮ LIỆU
echo ============================================
call "%CONTAINER_DIR%start-redis.bat"
call "%CONTAINER_DIR%start-mongodb.bat"
call "%CONTAINER_DIR%start-minio.bat"

echo.
echo Đợi 5 giây để databases khởi động hoàn toàn...
timeout /t 5 /nobreak >nul
echo.

echo ============================================
echo BƯỚC 2: KHỞI ĐỘNG CORE SERVICES
echo ============================================
call "%CONTAINER_DIR%start-openvidu-server.bat"
call "%CONTAINER_DIR%start-dashboard.bat"
call "%CONTAINER_DIR%start-operator.bat"

echo.
echo Đợi 3 giây để core services khởi động...
timeout /t 3 /nobreak >nul
echo.

echo ============================================
echo BƯỚC 3: KHỞI ĐỘNG GATEWAY VÀ APPLICATIONS
echo ============================================
call "%CONTAINER_DIR%start-caddy-proxy.bat"
call "%CONTAINER_DIR%start-openvidu-meet.bat"

echo.
echo ============================================
echo BƯỚC 4: KHỞI ĐỘNG STREAMING SERVICES (TÙY CHỌN)
echo ============================================
call "%CONTAINER_DIR%start-ingress.bat"
call "%CONTAINER_DIR%start-egress.bat"

echo.
echo ============================================
echo ✓ TẤT CẢ CONTAINERS ĐÃ KHỞI ĐỘNG!
echo ============================================
echo.
echo 📊 Dashboard: http://localhost:7880/dashboard
echo 🎥 OpenVidu Meet: http://localhost:9080
echo 💾 MinIO Console: http://localhost:7880/minio-console
echo.
echo Kiểm tra trạng thái: docker ps
echo.
pause
