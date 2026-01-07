@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG OPERATOR
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

set PARENT_DIR=%~dp0..

echo Đang kiểm tra container Operator...
docker ps -a --filter "name=operator" --format "{{.Names}}" | findstr /x "operator" >nul
if %errorlevel% equ 0 (
    echo Container Operator đã tồn tại. Đang khởi động lại...
    docker start operator
    if %errorlevel% equ 0 (
        echo ✓ Operator đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại Operator
        pause
        exit /b 1
    )
) else (
    echo Tạo container Operator mới...
    docker run -d ^
      --name operator ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      -v /var/run/docker.sock:/var/run/docker.sock ^
      -v openvidu-agents-config:/agents-config ^
      -v "%PARENT_DIR%:/deployment:ro" ^
      -e MODE=agent-manager-local ^
      -e DEPLOYMENT_FILES_DIR=/deployment ^
      -e AGENTS_CONFIG_DIR=/agents-config ^
      -e NETWORK_NAME=%NETWORK_NAME% ^
      -e AGENTS_CONFIG_VOLUME=openvidu-agents-config ^
      -e LIVEKIT_URL=ws://openvidu:7880/ ^
      -e LIVEKIT_API_KEY=%LIVEKIT_API_KEY% ^
      -e LIVEKIT_API_SECRET=%LIVEKIT_API_SECRET% ^
      -e REDIS_ADDRESS=redis:6379 ^
      -e REDIS_PASSWORD=%REDIS_PASSWORD% ^
      docker.io/openvidu/openvidu-operator:3.5.0
    
    if %errorlevel% equ 0 (
        echo ✓ Operator đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động Operator
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin Operator:
echo    Chức năng: Quản lý Agents AI, SIP trunking
echo    LiveKit URL: ws://openvidu:7880/
echo    Redis: redis:6379
echo.
echo Kiểm tra logs: docker logs operator
echo Dừng container: docker stop operator
echo.
pause
