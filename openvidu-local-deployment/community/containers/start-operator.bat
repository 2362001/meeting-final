@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG OPERATOR (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT Operator.
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"
set PARENT_DIR=%~dp0..

docker volume inspect openvidu-agents-config >nul 2>&1 || docker volume create openvidu-agents-config

echo 🏗️ Đang khởi chạy Operator...
echo.

docker run --rm ^
  --name operator ^
  --network %NETWORK_NAME% ^
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

echo.
echo ✓ Container Operator đã dừng.
pause
