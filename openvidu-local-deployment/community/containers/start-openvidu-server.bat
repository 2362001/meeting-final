@echo off
REM Tắt hiển thị các dòng lệnh thực thi
setlocal enabledelayedexpansion
REM Kích hoạt Delayed Expansion để lấy giá trị biến chính xác trong khối lệnh IF/FOR
chcp 65001 >nul
REM Chuyển bảng mã CMD sang UTF-8

echo ============================================
echo KHỞI ĐỘNG OPENVIDU SERVER (CHẾ ĐỘ TẠM THỜI)
echo ============================================
echo.
echo [!] LƯU Ý: Đóng cửa sổ này sẽ TỰ ĐỘNG TẮT OpenVidu Server.
echo.

REM Load cấu hình từ file config.bat ở thư mục cha
call "%~dp0..\config.bat"
REM Xác định thư mục cha để ánh xạ file cấu hình .yaml
set PARENT_DIR=%~dp0..

echo [1/2] Kiểm tra Docker Network...
docker network inspect %NETWORK_NAME% >nul 2>&1
if !errorlevel! neq 0 (
    docker network create %NETWORK_NAME%
)

echo [2/2] Đang khởi chạy OpenVidu Server...
echo --------------------------------------------
echo 📊 Thông tin:
echo    Giao thức: WebRTC (LiveKit Engine)
echo    Tín hiệu: ws://localhost:7880
echo --------------------------------------------
echo.

REM Chạy Docker Container:
REM --add-host: Cho phép container giao tiếp với IP máy thật (host)
REM -p 3478/udp: Cổng STUN/TURN giúp vượt tường lửa (NAT)
REM -p 7900-7999/udp: Dải cổng truyền dữ liệu video/audio thực tế
REM -v ...livekit.yaml: Ánh xạ file cấu hình chính của server
docker run --rm ^
  --name openvidu ^
  --network %NETWORK_NAME% ^
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

echo.
echo ✓ Container OpenVidu Server đã dừng.
pause
