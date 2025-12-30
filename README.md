# Hướng dẫn chạy Source Code Meeting (OpenVidu/LiveKit)

Tài liệu này hướng dẫn cách cài đặt và chạy toàn bộ hệ thống meeting bao gồm:

1. **Infrastructure**: OpenVidu/LiveKit (chạy qua Docker).
2. **Backend**: Spring Boot (thực hiện tạo token và quản lý session).
3. **Frontend**: Angular (giao diện người dùng).

---

## 1. Yêu cầu hệ thống

- **Docker Desktop** (Đã cài đặt và đang chạy).
- **Node.js** (Phiên bản 18+).
- **Java JDK 17** và **Maven**.

---

## 2. Các bước triển khai

### Bước 1: Khởi chạy Hạ tầng (OpenVidu Community)

Vào thư mục hạ tầng và cấu hình IP nội bộ:

1. Mở terminal tại thư mục gốc của dự án.
2. Di chuyển vào thư mục community:
   ```bash
   cd openvidu-local-deployment/community
   ```
3. Chạy file cấu hình (cho Windows):
   ```powershell
   .\configure_lan_private_ip_windows.bat
   ```
4. Khởi chạy các dịch vụ cần thiết bằng Docker Compose:
   ```bash
   docker compose up -d redis mongo minio openvidu caddy-proxy operator
   ```
   _Lưu ý: Bạn có thể chạy `docker compose up -d` để chạy toàn bộ dịch vụ, nhưng bộ máy tối giản trên là đủ cho việc phát triển (DEV)._

---

### Bước 2: Chạy Backend (Java Spring Boot)

Backend này chịu trách nhiệm cấp token cho frontend kết nối vào LiveKit.

1. Mở một terminal mới tại thư mục gốc.
2. Di chuyển vào thư mục `java`:
   ```bash
   cd java
   ```
3. Chạy ứng dụng bằng Maven:
   ```bash
   mvn spring-boot:run
   ```
   _Backend sẽ mặc định chạy tại: `http://localhost:6080`_

---

### Bước 3: Chạy Frontend (Angular)

1. Mở một terminal mới tại thư mục gốc.
2. Di chuyển vào thư mục `test_openvidu_fe`:
   ```bash
   cd test_openvidu_fe
   ```
3. Cài đặt các phụ thuộc (nếu là lần đầu):
   ```bash
   npm install
   ```
4. Khởi chạy ứng dụng:
   ```bash
   npm start
   ```
   _Frontend sẽ mặc định chạy tại: `http://localhost:4200`_

---

## 3. Sử dụng ứng dụng

1. Truy cập vào trình duyệt theo địa chỉ: [http://localhost:4200](http://localhost:4200).
2. Nhập tên phòng (Room Name) và tên của bạn (Participant Name).
3. Nhấn **Join** để bắt đầu cuộc họp.

### Thông tin cấu hình mặc định:

- **Application Server URL**: `http://127.0.0.1:6080/` (Backend Spring Boot).
- **LiveKit URL**: `ws://127.0.0.1:7880` (Cổng mặc định của LiveKit trong Docker).

---

## 4. Các lưu ý khi phát triển

- Nếu bạn thay đổi cổng của Backend, hãy cập nhật biến `APPLICATION_SERVER_URL` trong file `test_openvidu_fe/src/app/app.component.ts`.
- Đảm bảo Docker đang chạy trước khi khởi động Backend và Frontend.
