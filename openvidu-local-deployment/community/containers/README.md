# 📦 HƯỚNG DẪN SỬ DỤNG CÁC FILE CONTAINER RIÊNG LẺ

## 🎯 Tổng quan

Thư mục `containers/` chứa các file BAT để khởi động/dừng **từng container riêng lẻ**. Điều này cho phép bạn:
- ✅ Khởi động chỉ những service cần thiết
- ✅ Debug từng container một cách dễ dàng
- ✅ Tiết kiệm tài nguyên hệ thống
- ✅ Linh hoạt trong việc quản lý

---

## 📂 Cấu trúc thư mục

```
community/
├── config.bat                    # Cấu hình chung
├── 1-setup-environment.bat       # Setup ban đầu (chạy 1 lần)
├── containers/                   # Thư mục chứa scripts cho từng container
│   ├── start-redis.bat          # Khởi động Redis
│   ├── start-mongodb.bat        # Khởi động MongoDB
│   ├── start-minio.bat          # Khởi động MinIO
│   ├── start-openvidu-server.bat # Khởi động OpenVidu Server
│   ├── start-dashboard.bat      # Khởi động Dashboard
│   ├── start-operator.bat       # Khởi động Operator
│   ├── start-caddy-proxy.bat    # Khởi động Caddy Proxy
│   ├── start-openvidu-meet.bat  # Khởi động OpenVidu Meet
│   ├── start-ingress.bat        # Khởi động Ingress
│   ├── start-egress.bat         # Khởi động Egress
│   ├── start-all.bat            # Khởi động tất cả (theo thứ tự)
│   └── stop-all.bat             # Dừng tất cả
```

---

## 🔢 Thứ tự phụ thuộc giữa các containers

### Tầng 1: Cơ sở dữ liệu (phải khởi động trước)
1. **Redis** - Bộ nhớ đệm
2. **MongoDB** - Database chính
3. **MinIO** - Object storage

### Tầng 2: Core Services (phụ thuộc vào Tầng 1)
4. **OpenVidu Server** - Core engine WebRTC
5. **Dashboard** - Giao diện quản trị (cần MongoDB)
6. **Operator** - Quản lý agents (cần Redis)

### Tầng 3: Gateway & Applications (phụ thuộc vào Tầng 1 & 2)
7. **Caddy Proxy** - Reverse proxy
8. **OpenVidu Meet** - Web app (cần tất cả services trên)

### Tầng 4: Streaming (tùy chọn)
9. **Ingress** - Nhận livestream
10. **Egress** - Ghi hình/xuất stream

---

## 🚀 Cách sử dụng

### Khởi động tất cả (khuyến nghị cho người mới)

```
Double-click: containers/start-all.bat
```

Script này sẽ tự động khởi động tất cả containers theo đúng thứ tự.

---

### Khởi động từng container riêng lẻ

**Ví dụ 1: Chỉ khởi động Database + OpenVidu Server**

```
1. Double-click: containers/start-redis.bat
2. Double-click: containers/start-mongodb.bat
3. Double-click: containers/start-minio.bat
4. Đợi 5 giây
5. Double-click: containers/start-openvidu-server.bat
```

**Ví dụ 2: Khởi động hệ thống cơ bản (không có streaming)**

```
1. Double-click: containers/start-redis.bat
2. Double-click: containers/start-mongodb.bat
3. Double-click: containers/start-minio.bat
4. Đợi 5 giây
5. Double-click: containers/start-openvidu-server.bat
6. Double-click: containers/start-dashboard.bat
7. Double-click: containers/start-caddy-proxy.bat
8. Double-click: containers/start-openvidu-meet.bat
```

---

## 🔄 Tính năng thông minh của mỗi file

Mỗi file `start-*.bat` có các tính năng:

✅ **Kiểm tra container đã tồn tại**: Nếu container đã được tạo trước đó, script sẽ chỉ `start` lại thay vì tạo mới

✅ **Hiển thị thông tin**: Sau khi khởi động, hiển thị:
   - Port đang sử dụng
   - URL truy cập (nếu có)
   - Username/Password (nếu có)
   - Lệnh để xem logs

✅ **Báo lỗi rõ ràng**: Nếu có lỗi, script sẽ dừng lại và hiển thị thông báo

---

## 📋 Chi tiết từng container

### 1️⃣ Redis (`start-redis.bat`)
- **Chức năng**: Bộ nhớ đệm, quản lý session
- **Port**: 6379
- **Phụ thuộc**: Không
- **Bắt buộc**: ✅ Có

### 2️⃣ MongoDB (`start-mongodb.bat`)
- **Chức năng**: Database chính
- **Port**: 27017
- **Phụ thuộc**: Không
- **Bắt buộc**: ✅ Có

### 3️⃣ MinIO (`start-minio.bat`)
- **Chức năng**: Lưu trữ recordings
- **Port**: 9000
- **Console**: http://localhost:7880/minio-console
- **Phụ thuộc**: Không
- **Bắt buộc**: ✅ Có

### 4️⃣ OpenVidu Server (`start-openvidu-server.bat`)
- **Chức năng**: Core engine WebRTC
- **Ports**: 3478/udp, 7881/tcp, 7900-7999/udp
- **Phụ thuộc**: Redis, MongoDB, MinIO
- **Bắt buộc**: ✅ Có

### 5️⃣ Dashboard (`start-dashboard.bat`)
- **Chức năng**: Giao diện quản trị
- **URL**: http://localhost:7880/dashboard (qua Caddy)
- **Phụ thuộc**: MongoDB
- **Bắt buộc**: ⚠️ Không (nếu không cần quản trị)

### 6️⃣ Operator (`start-operator.bat`)
- **Chức năng**: Quản lý Agents AI, SIP
- **Phụ thuộc**: Redis, OpenVidu Server
- **Bắt buộc**: ⚠️ Không (nếu không dùng Agents)

### 7️⃣ Caddy Proxy (`start-caddy-proxy.bat`)
- **Chức năng**: Reverse proxy, gateway
- **Port**: 7880 (main)
- **Phụ thuộc**: Tất cả services khác
- **Bắt buộc**: ✅ Có (để truy cập Dashboard, MinIO Console)

### 8️⃣ OpenVidu Meet (`start-openvidu-meet.bat`)
- **Chức năng**: Ứng dụng họp web
- **URL**: http://localhost:9080
- **Phụ thuộc**: Tất cả services trên
- **Bắt buộc**: ⚠️ Không (nếu bạn có frontend riêng)

### 9️⃣ Ingress (`start-ingress.bat`)
- **Chức năng**: Nhận livestream từ OBS/RTMP
- **Port**: 1935 (RTMP)
- **Phụ thuộc**: OpenVidu Server
- **Bắt buộc**: ❌ Không (chỉ khi cần streaming input)

### 🔟 Egress (`start-egress.bat`)
- **Chức năng**: Ghi hình, xuất stream
- **Phụ thuộc**: OpenVidu Server, MinIO
- **Bắt buộc**: ❌ Không (chỉ khi cần recording)

---

## 🛑 Dừng containers

### Dừng tất cả
```
Double-click: containers/stop-all.bat
```

### Dừng từng container riêng lẻ
```powershell
docker stop <container_name>
```

Ví dụ:
```powershell
docker stop openvidu-meet
docker stop egress
```

---

## 🔍 Debug và kiểm tra

### Xem logs của container
```powershell
docker logs <container_name>
```

### Xem logs realtime
```powershell
docker logs -f <container_name>
```

### Kiểm tra container đang chạy
```powershell
docker ps
```

### Kiểm tra tất cả containers (kể cả đã dừng)
```powershell
docker ps -a
```

### Vào bên trong container
```powershell
docker exec -it <container_name> /bin/sh
```

---

## 💡 Các kịch bản sử dụng

### Kịch bản 1: Development (tiết kiệm tài nguyên)
Chỉ khởi động các service cần thiết:
```
✅ Redis
✅ MongoDB
✅ MinIO
✅ OpenVidu Server
✅ Caddy Proxy
✅ OpenVidu Meet
❌ Dashboard (không cần)
❌ Operator (không cần)
❌ Ingress (không cần)
❌ Egress (không cần)
```

### Kịch bản 2: Testing Recording
Cần thêm Egress:
```
✅ Tất cả services cơ bản
✅ Egress (để test recording)
```

### Kịch bản 3: Testing Livestream Input
Cần thêm Ingress:
```
✅ Tất cả services cơ bản
✅ Ingress (để test RTMP input từ OBS)
```

### Kịch bản 4: Production Full
Khởi động tất cả:
```
✅ Tất cả 10 containers
```

---

## ⚠️ Lưu ý quan trọng

1. **Thứ tự khởi động**: Luôn khởi động theo thứ tự phụ thuộc (Database → Core → Gateway → Apps)

2. **Đợi khởi động hoàn tất**: Sau khi khởi động Database, đợi 5-10 giây trước khi khởi động services khác

3. **Kiểm tra logs**: Nếu container không hoạt động, kiểm tra logs bằng `docker logs <container_name>`

4. **Container đã tồn tại**: Nếu bạn chạy file `start-*.bat` lần thứ 2, nó sẽ chỉ `start` lại container cũ, không tạo mới

5. **Xóa container**: Nếu muốn tạo lại container từ đầu:
   ```powershell
   docker stop <container_name>
   docker rm <container_name>
   ```
   Sau đó chạy lại file `start-*.bat`

---

## 🆘 Xử lý sự cố

### Container không khởi động được?
1. Kiểm tra logs: `docker logs <container_name>`
2. Kiểm tra network đã tạo chưa: `docker network ls | findstr openvidu`
3. Kiểm tra volumes đã tạo chưa: `docker volume ls | findstr openvidu`
4. Chạy lại setup: `1-setup-environment.bat`

### Port bị chiếm?
Kiểm tra port đang được sử dụng:
```powershell
netstat -ano | findstr :<port_number>
```

### Container bị crash liên tục?
1. Xem logs để tìm lỗi
2. Kiểm tra cấu hình trong `config.bat`
3. Đảm bảo các service phụ thuộc đã chạy

---

**Chúc bạn sử dụng thành công! 🎉**
