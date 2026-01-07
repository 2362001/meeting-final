@echo off
REM Tắt hiển thị các dòng lệnh thực thi
setlocal enabledelayedexpansion
REM Kích hoạt Delayed Expansion để lấy giá trị biến chính xác trong khối lệnh IF/FOR
chcp 65001 >nul
REM Chuyển bảng mã CMD sang UTF-8

echo ============================================
echo KHỞI ĐỘNG STREAMING SERVICES (TẠM THỜI)
echo ============================================
echo.
echo Chọn service muốn chạy trong cửa sổ này:
echo [1] INGRESS (Nhận stream từ bên ngoài như OBS/RTMP)
echo [2] EGRESS  (Ghi hình cuộc họp / Xuất stream ra Youtube)
echo.

set /p choice="Nhập (1/2): "

REM Load cấu hình từ file config.bat ở thư mục cha
call "%~dp0..\config.bat"
set PARENT_DIR=%~dp0..

if "%choice%"=="1" (
    echo.
    echo 📡 ĐANG CHẠY INGRESS...
    echo Nhận luồng RTMP tại cổng 1935
    echo --------------------------------------------
    REM Ingress: Cổng vào cho các luồng stream bên ngoài vào OpenVidu
    docker run --rm ^
      --name ingress ^
      --network %NETWORK_NAME% ^
      --add-host host.docker.internal:host-gateway ^
      -p 1935:1935 ^
      -p 8085:8085 ^
      -p 7895:7895/udp ^
      -v "%PARENT_DIR%\ingress.yaml:/etc/ingress.yaml:ro" ^
      -e INGRESS_CONFIG_FILE=/etc/ingress.yaml ^
      docker.io/openvidu/ingress:3.5.0
) else if "%choice%"=="2" (
    echo.
    echo 📀 ĐANG CHẠY EGRESS...
    echo Xử lý Recording / Multimedia Output
    echo --------------------------------------------
    REM Egress: Trích xuất video từ phòng họp để ghi đĩa hoặc stream tiếp
    docker volume inspect openvidu-egress-data >nul 2>&1 || docker volume create openvidu-egress-data
    docker run --rm ^
      --name egress ^
      --network %NETWORK_NAME% ^
      --add-host host.docker.internal:host-gateway ^
      -v "%PARENT_DIR%\egress.yaml:/etc/egress.yaml:ro" ^
      -v openvidu-egress-data:/home/egress/tmp ^
      -e EGRESS_CONFIG_FILE=/etc/egress.yaml ^
      docker.io/openvidu/egress:3.5.0
) else (
    echo Lựa chọn không hợp lệ.
)

echo.
echo ✓ Service đã dừng.
pause
