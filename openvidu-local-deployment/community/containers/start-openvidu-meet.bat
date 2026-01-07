@echo off
REM Tắt hiển thị các dòng lệnh thực thi
setlocal enabledelayedexpansion
REM Kích hoạt Delayed Expansion để lấy giá trị biến chính xác trong khối lệnh IF/FOR
chcp 65001 >nul
REM Chuyển bảng mã CMD sang UTF-8

echo ============================================
echo KHỞI ĐỘNG OPENVIDU MEET (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT App Meet.
echo.

REM Load cấu hình từ file config.bat ở thư mục cha
call "%~dp0..\config.bat"
set PARENT_DIR=%~dp0..

echo [1/2] Kiểm tra Docker Network...
docker network inspect %NETWORK_NAME% >nul 2>&1 || docker network create %NETWORK_NAME%

echo [2/2] Đang khởi chạy OpenVidu Meet...
echo --------------------------------------------
echo 🎥 CAMERA/MEET APP:
echo    URL: http://localhost:9080
echo    User: %MEET_INITIAL_ADMIN_USER%
echo    Pass: %MEET_INITIAL_ADMIN_PASSWORD%
echo --------------------------------------------
echo.

REM Chạy Docker Container:
REM Ứng dụng họp mẫu tích hợp sâu với Server (WebRTC), Redis (Session),
REM MongoDB (User/History) và MinIO (Recordings)
docker run --rm ^
  --name openvidu-meet ^
  --network %NETWORK_NAME% ^
  --add-host host.docker.internal:host-gateway ^
  -p 9080:6080 ^
  -v "%PARENT_DIR%\scripts\entrypoint_openvidu_meet.sh:/scripts/entrypoint.sh:ro" ^
  -v "%PARENT_DIR%\scripts\utils.sh:/scripts/utils.sh:ro" ^
  -e USE_HTTPS=%USE_HTTPS% ^
  -e LAN_MODE=%LAN_MODE% ^
  -e LAN_DOMAIN=%LAN_DOMAIN% ^
  -e LAN_PRIVATE_IP=%LAN_PRIVATE_IP% ^
  -e SERVER_PORT=6080 ^
  -e MEET_LOG_LEVEL=info ^
  -e MEET_NAME_ID=openviduMeet-LOCAL ^
  -e MEET_INITIAL_API_KEY=%MEET_INITIAL_API_KEY% ^
  -e MEET_INITIAL_ADMIN_USER=%MEET_INITIAL_ADMIN_USER% ^
  -e MEET_INITIAL_ADMIN_PASSWORD=%MEET_INITIAL_ADMIN_PASSWORD% ^
  -e MEET_COOKIE_SECURE=false ^
  -e MEET_INITIAL_WEBHOOK_ENABLED=true ^
  -e MEET_INITIAL_WEBHOOK_URL=http://host.docker.internal:6080/webhook ^
  -e LIVEKIT_URL_PRIVATE=ws://openvidu:7880/ ^
  -e LIVEKIT_API_KEY=%LIVEKIT_API_KEY% ^
  -e LIVEKIT_API_SECRET=%LIVEKIT_API_SECRET% ^
  -e MEET_S3_BUCKET=openvidu-appdata ^
  -e MEET_S3_SUBBUCKET=openvidu-meet ^
  -e MEET_S3_SERVICE_ENDPOINT=http://minio:9000 ^
  -e MEET_S3_ACCESS_KEY=%MINIO_ACCESS_KEY% ^
  -e MEET_S3_SECRET_KEY=%MINIO_SECRET_KEY% ^
  -e MEET_AWS_REGION=us-east-1 ^
  -e MEET_S3_WITH_PATH_STYLE_ACCESS=true ^
  -e MEET_REDIS_HOST=redis ^
  -e MEET_REDIS_PORT=6379 ^
  -e MEET_REDIS_PASSWORD=%REDIS_PASSWORD% ^
  -e MEET_REDIS_DB=0 ^
  -e MEET_MONGO_URI=mongodb://%MONGO_ADMIN_USERNAME%:%MONGO_ADMIN_PASSWORD%@mongo:27017/?replicaSet=rs0^&readPreference=primaryPreferred ^
  --entrypoint /bin/sh ^
  docker.io/openvidu/openvidu-meet:3.5.0 ^
  /scripts/entrypoint.sh

echo.
echo ✓ Container OpenVidu Meet đã dừng.
pause
