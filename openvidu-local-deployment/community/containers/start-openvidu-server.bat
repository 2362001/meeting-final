@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG OPENVIDU SERVER (Core Engine)
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

set PARENT_DIR=%~dp0..

echo Đang kiểm tra container OpenVidu Server...
docker ps -a --filter "name=openvidu" --format "{{.Names}}" | findstr /x "openvidu" >nul
if %errorlevel% equ 0 (
    echo Container OpenVidu đã tồn tại. Đang khởi động lại...
    docker start openvidu
    if %errorlevel% equ 0 (
        echo ✓ OpenVidu Server đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại OpenVidu Server
        pause
        exit /b 1
    )
) else (
    echo Tạo container OpenVidu Server mới...
    docker run -d ^
      --name openvidu ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      --add-host host.docker.internal:host-gateway ^
      -p 3478:3478/udp ^
      -p 7881:7881/tcp ^
      -p 7900-7999:7900-7999/udp ^
      -v "%PARENT_DIR%\livekit.yaml:/etc/livekit.yaml:ro" ^
      -v "%PARENT_DIR%\scripts\entrypoint_openvidu.sh:/scripts/entrypoint.sh:ro" ^
      -e LAN_MODE=%LAN_MODE% ^
      -e LAN_PRIVATE_IP=%LAN_PRIVATE_IP% ^
      --entrypoint /bin/sh ^
      docker.io/openvidu/openvidu-server:3.5.0 ^
      /scripts/entrypoint.sh --config /etc/livekit.yaml
    
    if %errorlevel% equ 0 (
        echo ✓ OpenVidu Server đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động OpenVidu Server
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin OpenVidu Server:
echo    STUN/TURN Port: 3478/udp
echo    WebRTC Port: 7881/tcp
echo    Media Ports: 7900-7999/udp
echo    WebSocket: ws://localhost:7880/
echo.
echo Kiểm tra logs: docker logs openvidu
echo Dừng container: docker stop openvidu
echo.
pause
