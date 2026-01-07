@echo off
chcp 65001 >nul
echo ============================================
echo KHỞI ĐỘNG MINIO (Object Storage)
echo ============================================
echo.

REM Load cấu hình từ thư mục cha
call "%~dp0..\config.bat"

echo Đang kiểm tra container MinIO...
docker ps -a --filter "name=minio" --format "{{.Names}}" | findstr /x "minio" >nul
if %errorlevel% equ 0 (
    echo Container MinIO đã tồn tại. Đang khởi động lại...
    docker start minio
    if %errorlevel% equ 0 (
        echo ✓ MinIO đã khởi động lại thành công
    ) else (
        echo ✗ Không thể khởi động lại MinIO
        pause
        exit /b 1
    )
) else (
    echo Tạo container MinIO mới...
    docker run -d ^
      --name minio ^
      --network %NETWORK_NAME% ^
      --restart unless-stopped ^
      -p 9000:9000 ^
      -v openvidu-minio-data:/bitnami/minio/data ^
      -v openvidu-minio-certs:/certs ^
      -e MINIO_ROOT_USER=%MINIO_ACCESS_KEY% ^
      -e MINIO_ROOT_PASSWORD=%MINIO_SECRET_KEY% ^
      -e MINIO_DEFAULT_BUCKETS=openvidu-appdata ^
      -e MINIO_CONSOLE_SUBPATH=/minio-console ^
      -e MINIO_BROWSER=on ^
      -e MINIO_BROWSER_REDIRECT_URL=http://localhost:7880/minio-console ^
      docker.io/openvidu/minio:2025.9.7-debian-12-r3
    
    if %errorlevel% equ 0 (
        echo ✓ MinIO đã khởi động thành công
    ) else (
        echo ✗ Lỗi khi khởi động MinIO
        pause
        exit /b 1
    )
)

echo.
echo 📊 Thông tin MinIO:
echo    Port: 9000
echo    Console: http://localhost:7880/minio-console
echo    Access Key: %MINIO_ACCESS_KEY%
echo    Secret Key: %MINIO_SECRET_KEY%
echo    Default Bucket: openvidu-appdata
echo.
echo Kiểm tra logs: docker logs minio
echo Dừng container: docker stop minio
echo.
pause
