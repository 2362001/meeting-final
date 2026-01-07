@echo off
chcp 65001 >nul
echo ============================================
echo DỪNG TẤT CẢ CONTAINERS OPENVIDU
echo ============================================
echo.

REM Load cấu hình
call "%~dp0config.bat"

echo Đang dừng tất cả containers...
echo.

docker stop openvidu-meet 2>nul
docker stop caddy-proxy 2>nul
docker stop operator 2>nul
docker stop dashboard 2>nul
docker stop ingress 2>nul
docker stop egress 2>nul
docker stop openvidu 2>nul
docker stop minio 2>nul
docker stop mongo 2>nul
docker stop redis 2>nul

echo.
echo ✓ Đã dừng tất cả containers
echo.

echo Bạn có muốn XÓA các containers không? (Y/N)
echo (Chỉ xóa containers, KHÔNG xóa dữ liệu)
set /p choice="Nhập lựa chọn: "

if /i "%choice%"=="Y" (
    echo.
    echo Đang xóa containers...
    docker rm openvidu-meet 2>nul
    docker rm caddy-proxy 2>nul
    docker rm operator 2>nul
    docker rm dashboard 2>nul
    docker rm ingress 2>nul
    docker rm egress 2>nul
    docker rm openvidu 2>nul
    docker rm minio 2>nul
    docker rm mongo 2>nul
    docker rm redis 2>nul
    echo ✓ Đã xóa tất cả containers
) else (
    echo ℹ Giữ lại containers (có thể start lại bằng: docker start ^<container_name^>)
)

echo.
echo ============================================
echo ✓ HOÀN TẤT!
echo ============================================
echo.
pause
