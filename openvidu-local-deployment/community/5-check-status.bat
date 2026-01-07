@echo off
chcp 65001 >nul
echo ============================================
echo KIỂM TRA TRẠNG THÁI OPENVIDU
echo ============================================
echo.

REM Load cấu hình
call "%~dp0config.bat"

echo 📊 Danh sách containers đang chạy:
echo ============================================
docker ps --filter "network=%NETWORK_NAME%" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 📦 Danh sách volumes:
echo ============================================
docker volume ls --filter "name=openvidu-" --format "table {{.Name}}\t{{.Driver}}"
echo.

echo 🌐 Network:
echo ============================================
docker network inspect %NETWORK_NAME% --format "{{.Name}} - {{len .Containers}} containers" 2>nul
if %errorlevel% neq 0 (
    echo ⚠️  Network chưa được tạo
)
echo.

echo 🔗 Các URL truy cập:
echo ============================================
echo Dashboard:      http://localhost:7880/dashboard
echo OpenVidu Meet:  http://localhost:9080
echo MinIO Console:  http://localhost:7880/minio-console
echo.

echo 💡 Kiểm tra logs của container cụ thể:
echo    docker logs ^<container_name^>
echo.
echo    Ví dụ: docker logs openvidu
echo.
pause
