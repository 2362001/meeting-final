# 📋 HƯỚNG DẪN SỬ DỤNG CÁC FILE SCRIPT

## 🎯 Mục đích
Các file `.bat` này giúp bạn chạy OpenVidu **KHÔNG CẦN** Docker Compose, chỉ cần **double-click** vào file là chạy.

---

## 📂 Danh sách các file

### 1️⃣ **config.bat** - File cấu hình
- **Mục đích**: Chứa tất cả các biến môi trường (mật khẩu, API keys, v.v.)
- **Khi nào dùng**: Chỉnh sửa file này để thay đổi cấu hình trước khi chạy
- **⚠️ Quan trọng**: Đổi mật khẩu mặc định trước khi deploy production!

### 2️⃣ **1-setup-environment.bat** - Thiết lập môi trường
- **Mục đích**: Tạo Docker network, volumes và chạy setup ban đầu
- **Khi nào dùng**: Chạy **1 LẦN DUY NHẤT** khi cài đặt lần đầu
- **Thứ tự**: Chạy file này TRƯỚC KHI chạy file start

### 3️⃣ **2-start-openvidu.bat** - Khởi động OpenVidu
- **Mục đích**: Khởi động tất cả containers OpenVidu
- **Khi nào dùng**: Mỗi lần muốn start hệ thống
- **Lưu ý**: Cần chạy file setup trước (chỉ 1 lần đầu)

### 4️⃣ **3-stop-openvidu.bat** - Dừng OpenVidu
- **Mục đích**: Dừng tất cả containers (có tùy chọn xóa containers)
- **Khi nào dùng**: Khi muốn tắt hệ thống
- **Lưu ý**: Dữ liệu vẫn được giữ trong volumes

### 5️⃣ **4-cleanup-openvidu.bat** - Xóa toàn bộ
- **Mục đích**: Xóa HOÀN TOÀN containers, volumes, network
- **Khi nào dùng**: Khi muốn reset về trạng thái ban đầu
- **⚠️ CẢNH BÁO**: Sẽ XÓA TẤT CẢ DỮ LIỆU (recordings, database, v.v.)

### 6️⃣ **5-check-status.bat** - Kiểm tra trạng thái
- **Mục đích**: Xem trạng thái containers, volumes, network
- **Khi nào dùng**: Khi muốn kiểm tra xem hệ thống có đang chạy không

---

## 🚀 Hướng dẫn sử dụng từng bước

### Lần đầu tiên cài đặt:

1. **Chỉnh sửa cấu hình** (tùy chọn):
   - Double-click vào `config.bat` để xem/sửa
   - Hoặc mở bằng Notepad và thay đổi mật khẩu

2. **Chạy setup** (chỉ 1 lần):
   ```
   Double-click: 1-setup-environment.bat
   ```
   - Đợi cho đến khi thấy "✓ THIẾT LẬP HOÀN TẤT!"

3. **Khởi động OpenVidu**:
   ```
   Double-click: 2-start-openvidu.bat
   ```
   - Đợi khoảng 30-60 giây để tất cả services khởi động

4. **Truy cập ứng dụng**:
   - Dashboard: http://localhost:7880/dashboard
   - OpenVidu Meet: http://localhost:9080
   - MinIO Console: http://localhost:7880/minio-console

### Các lần sau:

- **Khởi động**: Double-click `2-start-openvidu.bat`
- **Dừng lại**: Double-click `3-stop-openvidu.bat`
- **Kiểm tra**: Double-click `5-check-status.bat`

---

## 🔧 Xử lý sự cố

### Container không khởi động được?
1. Chạy `5-check-status.bat` để xem container nào bị lỗi
2. Xem logs: Mở PowerShell và chạy:
   ```powershell
   docker logs <tên_container>
   ```
   Ví dụ: `docker logs openvidu`

### Port bị chiếm?
- Kiểm tra xem có ứng dụng nào đang dùng port:
  - 7880 (Caddy)
  - 9080 (OpenVidu Meet)
  - 27017 (MongoDB)
  - 6379 (Redis)
  - 9000 (MinIO)

### Muốn reset hoàn toàn?
1. Chạy `4-cleanup-openvidu.bat`
2. Nhập `YES` để xác nhận
3. Chạy lại từ bước 1 (setup environment)

---

## 📊 Thông tin đăng nhập mặc định

### Dashboard
- URL: http://localhost:7880/dashboard
- Username: `admin`
- Password: `admin`

### OpenVidu Meet
- URL: http://localhost:9080
- Username: `admin`
- Password: `admin`

### MinIO Console
- URL: http://localhost:7880/minio-console
- Username: `minioadmin`
- Password: `minioadmin_password_123`

**⚠️ Lưu ý**: Đổi các mật khẩu này trong file `config.bat` trước khi deploy production!

---

## 💡 Tips

1. **Chạy ở chế độ Administrator**: Nếu gặp lỗi permission, click phải vào file `.bat` → "Run as administrator"

2. **Xem logs realtime**: 
   ```powershell
   docker logs -f <container_name>
   ```

3. **Restart 1 container cụ thể**:
   ```powershell
   docker restart <container_name>
   ```

4. **Kiểm tra tài nguyên**:
   ```powershell
   docker stats
   ```

---

## 🆘 Cần trợ giúp?

- Kiểm tra logs của container bị lỗi
- Đảm bảo Docker Desktop đang chạy
- Đảm bảo có đủ dung lượng ổ cứng (ít nhất 10GB)
- Đảm bảo có đủ RAM (khuyến nghị 8GB+)

---

## 🔄 So sánh với Docker Compose

| Tính năng | Script .bat | Docker Compose |
|-----------|-------------|----------------|
| Dễ sử dụng | ✅ Double-click | ⚠️ Cần gõ lệnh |
| Tùy chỉnh | ⚠️ Sửa file .bat | ✅ Sửa file .yml |
| Quản lý | ⚠️ Nhiều file | ✅ 1 file duy nhất |
| Phù hợp cho | Người mới, demo | Production, dev team |

---

**Chúc bạn sử dụng thành công! 🎉**
