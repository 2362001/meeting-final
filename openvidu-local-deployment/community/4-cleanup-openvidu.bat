@echo off
chcp 65001 >nul
color 0C
echo ============================================
echo ⚠️  CẢNH BÁO: XÓA TOÀN BỘ DỮ LIỆU OPENVIDU
echo ============================================
echo.
echo Script này sẽ XÓA:
echo   - Tất cả containers
echo   - Tất cả volumes (dữ liệu database, recordings, etc.)
echo   - Docker network
echo.
echo ⚠️  HÀNH ĐỘNG NÀY KHÔNG THỂ HOÀN TÁC!
echo.
echo Bạn có CHẮC CHẮN muốn tiếp tục? (YES/NO)
set /p confirm="Nhập YES để xác nhận: "

if /i NOT "%confirm%"=="YES" (
    echo.
    echo ℹ Đã hủy thao tác
    pause
    exit /b 0
)

echo.
echo ============================================
echo ĐANG XÓA DỮ LIỆU...
echo ============================================
echo.

REM Load cấu hình
call "%~dp0config.bat"

echo [1/3] Dừng và xóa tất cả containers...
docker stop openvidu-meet caddy-proxy operator dashboard ingress egress openvidu minio mongo redis 2>nul
docker rm openvidu-meet caddy-proxy operator dashboard ingress egress openvidu minio mongo redis 2>nul
echo ✓ Đã xóa containers
echo.

echo [2/3] Xóa tất cả volumes...
docker volume rm openvidu-redis 2>nul
docker volume rm openvidu-minio-data 2>nul
docker volume rm openvidu-minio-certs 2>nul
docker volume rm openvidu-mongo-data 2>nul
docker volume rm openvidu-egress-data 2>nul
docker volume rm openvidu-agents-config 2>nul
echo ✓ Đã xóa volumes
echo.

echo [3/3] Xóa network...
docker network rm %NETWORK_NAME% 2>nul
echo ✓ Đã xóa network
echo.

echo ============================================
echo ✓ ĐÃ XÓA TOÀN BỘ DỮ LIỆU!
echo ============================================
echo.
echo Để cài đặt lại, chạy file: 1-setup-environment.bat
echo.
pause
