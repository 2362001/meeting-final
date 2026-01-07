@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG INGRESS (Livestream Input)
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

set PARENT_DIR=%~dp0..

echo Đang kiểm tra container Ingress...
docker ps -a --filter "name=ingress" --format "{{.Names}}" | findstr /x "ingress" >nul
if %errorlevel% equ 0 (
    echo Container Ingress đã tồn tại. Đang khởi động lại...
    docker start ingress
    if %errorlevel% equ 0 (
        echo ✓ Ingress đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại Ingress
        pause
        exit /b 1
    )
) else (
    echo Tạo container Ingress mới...
    docker run -d ^
      --name ingress ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      --add-host host.docker.internal:host-gateway ^
      -p 1935:1935 ^
      -p 8085:8085 ^
      -p 7895:7895/udp ^
      -v "%PARENT_DIR%\ingress.yaml:/etc/ingress.yaml:ro" ^
      -e INGRESS_CONFIG_FILE=/etc/ingress.yaml ^
      docker.io/openvidu/ingress:3.5.0
    
    if %errorlevel% equ 0 (
        echo ✓ Ingress đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động Ingress
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin Ingress:
echo    Chức năng: Nhận livestream từ OBS/RTMP vào phòng họp
echo    RTMP Port: 1935
echo    HTTP Port: 8085
echo    SRT Port: 7895/udp
echo.
echo Kiểm tra logs: docker logs ingress
echo Dừng container: docker stop ingress
echo.
pause
