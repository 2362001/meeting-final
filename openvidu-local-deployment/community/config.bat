@echo off
REM ============================================
REM CẤU HÌNH OPENVIDU - Chỉnh sửa các giá trị này theo nhu cầu
REM ============================================

REM Đường dẫn thư mục hiện tại
set CURRENT_DIR=%~dp0

REM Cấu hình Redis
set REDIS_PASSWORD=redis_password_123

REM Cấu hình MongoDB
set MONGO_ADMIN_USERNAME=admin
set MONGO_ADMIN_PASSWORD=mongo_password_123

REM Cấu hình MinIO (Object Storage)
set MINIO_ACCESS_KEY=minioadmin
set MINIO_SECRET_KEY=minioadmin_password_123

REM Cấu hình LiveKit/OpenVidu
set LIVEKIT_API_KEY=devkey
set LIVEKIT_API_SECRET=secret

REM Cấu hình Dashboard
set DASHBOARD_ADMIN_USERNAME=admin
set DASHBOARD_ADMIN_PASSWORD=admin

REM Cấu hình OpenVidu Meet
set MEET_INITIAL_ADMIN_USER=admin
set MEET_INITIAL_ADMIN_PASSWORD=admin
set MEET_INITIAL_API_KEY=meet-api-key

REM Cấu hình Network
set NETWORK_NAME=openvidu-community

REM Cấu hình chung
set USE_HTTPS=false
set LAN_MODE=false
set LAN_DOMAIN=
set LAN_PRIVATE_IP=

echo [CONFIG] Đã load cấu hình thành công!
