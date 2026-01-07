@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG OPENVIDU MEET (Web App)
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

set PARENT_DIR=%~dp0..

echo Đang kiểm tra container OpenVidu Meet...
docker ps -a --filter "name=openvidu-meet" --format "{{.Names}}" | findstr /x "openvidu-meet" >nul
if %errorlevel% equ 0 (
    echo Container OpenVidu Meet đã tồn tại. Đang khởi động lại...
    docker start openvidu-meet
    if %errorlevel% equ 0 (
        echo ✓ OpenVidu Meet đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại OpenVidu Meet
        pause
        exit /b 1
    )
) else (
    echo Tạo container OpenVidu Meet mới...
    docker run -d ^
      --name openvidu-meet ^
      --network %NETWORK_NAME% ^
      --restart on-failure ^
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
    
    if %errorlevel% equ 0 (
        echo ✓ OpenVidu Meet đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động OpenVidu Meet
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin OpenVidu Meet:
echo    URL: http://localhost:9080
echo    Username: %MEET_INITIAL_ADMIN_USER%
echo    Password: %MEET_INITIAL_ADMIN_PASSWORD%
echo    API Key: %MEET_INITIAL_API_KEY%
echo.
echo Kiểm tra logs: docker logs openvidu-meet
echo Dừng container: docker stop openvidu-meet
echo.
pause
