Làm theo thứ tự 3 bước sau:

### 1. Hạ tầng (Sử dụng File BAT trong thư mục containers)
Mở Terminal tại thư mục: `openvidu-local-deployment/community/containers`

# File tổng hợp chạy 1 lần run tất cả các service:
.\start-all.bat

# Chi tiết các service sẽ được chạy (theo thứ tự):
1.  .\start-redis.bat            # Cache
2.  .\start-mongodb.bat          # Database
3.  .\start-minio.bat            # Storage (Ghi hình)
4.  .\start-openvidu-server.bat  # LiveKit/OpenVidu Core
5.  .\start-dashboard.bat        # Trang quản trị
6.  .\start-operator.bat         # Quản lý dịch vụ
7.  .\start-caddy-proxy.bat      # Proxy/SSL
8.  .\start-openvidu-meet.bat    # Giao diện Demo

*Lưu ý: Nếu muốn dừng hạ tầng tất cả các service, chạy file .\stop-all.bat`

### 2. Backend (Java)
Mở Terminal tại thư mục: `java`
Chạy : mvn spring-boot:run


### 3. Frontend (Angular)
Mở Terminal tại thư mục: `test_openvidu_fe`

Chạy : npm install   
Chạy : npm start

---
**Truy cập:** [http://localhost:4200](http://localhost:4200)
