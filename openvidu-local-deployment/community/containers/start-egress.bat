@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG EGRESS (Recording/Streaming Output)
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

set PARENT_DIR=%~dp0..

echo Đang kiểm tra container Egress...
docker ps -a --filter "name=egress" --format "{{.Names}}" | findstr /x "egress" >nul
if %errorlevel% equ 0 (
    echo Container Egress đã tồn tại. Đang khởi động lại...
    docker start egress
    if %errorlevel% equ 0 (
        echo ✓ Egress đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại Egress
        pause
        exit /b 1
    )
) else (
    echo Tạo container Egress mới...
    docker run -d ^
      --name egress ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      --add-host host.docker.internal:host-gateway ^
      -v "%PARENT_DIR%\egress.yaml:/etc/egress.yaml:ro" ^
      -v openvidu-egress-data:/home/egress/tmp ^
      -e EGRESS_CONFIG_FILE=/etc/egress.yaml ^
      docker.io/openvidu/egress:3.5.0
    
    if %errorlevel% equ 0 (
        echo ✓ Egress đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động Egress
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin Egress:
echo    Chức năng: Ghi hình cuộc họp, xuất stream ra Youtube/Facebook
echo    Lưu trữ tạm: /home/egress/tmp
echo.
echo ⚠️  Lưu ý: Service này tốn nhiều CPU khi encoding video
echo.
echo Kiểm tra logs: docker logs egress
echo Dừng container: docker stop egress
echo.
pause
