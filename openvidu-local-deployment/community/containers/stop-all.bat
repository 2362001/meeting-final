@echo off
chcp 65001 >nul
echo ============================================
echo DỪNG TẤT CẢ CONTAINERS
echo ============================================
echo.

echo Đang dừng tất cả containers OpenVidu...
echo.

docker stop egress 2>nul && echo ✓ Đã dừng Egress
docker stop ingress 2>nul && echo ✓ Đã dừng Ingress
docker stop openvidu-meet 2>nul && echo ✓ Đã dừng OpenVidu Meet
docker stop caddy-proxy 2>nul && echo ✓ Đã dừng Caddy Proxy
docker stop operator 2>nul && echo ✓ Đã dừng Operator
docker stop dashboard 2>nul && echo ✓ Đã dừng Dashboard
docker stop openvidu 2>nul && echo ✓ Đã dừng OpenVidu Server
docker stop minio 2>nul && echo ✓ Đã dừng MinIO
docker stop mongo 2>nul && echo ✓ Đã dừng MongoDB
docker stop redis 2>nul && echo ✓ Đã dừng Redis

echo.
echo ============================================
echo ✓ ĐÃ DỪNG TẤT CẢ CONTAINERS
echo ============================================
echo.
echo Để khởi động lại: chạy start-all.bat hoặc các file start riêng lẻ
echo Để xóa containers: docker rm ^<container_name^>
echo.
pause
