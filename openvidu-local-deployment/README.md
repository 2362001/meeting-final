# OpenVidu Local Deployment
Docker Compose files to run OpenVidu locally for development purposes.

## Requirements
On **Windows** and **MacOS**:
- **Docker Desktop**

On **Linux**:
- **Docker**
- **Docker Compose**

---

## OpenVidu COMMUNITY

### Install OpenVidu COMMUNITY

#### Windows

```sh
git clone https://github.com/OpenVidu/openvidu-local-deployment
cd openvidu-local-deployment/community
.\configure_lan_private_ip_windows.bat
```

#### Mac

```sh
git clone https://github.com/OpenVidu/openvidu-local-deployment
cd openvidu-local-deployment/community
./configure_lan_private_ip_mac.sh
```

#### Linux

```sh
git clone https://github.com/OpenVidu/openvidu-local-deployment
cd openvidu-local-deployment/community
./configure_lan_private_ip_linux.sh
```

### Run OpenVidu COMMUNITY

**Chạy toàn bộ hệ thống:**
```sh
docker compose up -d
```

**Chạy bộ khung tối giản (Khuyên dùng cho DEV):**
Dùng lệnh này để tiết kiệm tài nguyên máy, chỉ chạy các dịch vụ bắt buộc.
```sh
docker compose up -d redis mongo minio openvidu caddy-proxy operator
```

**Chạy 1 dịch vụ cụ thể:**
```sh
docker compose up -d <tên_dịch_vụ>
```

**Dừng hệ thống:**
```sh
docker compose down
```

---

## OpenVidu PRO (Evaluation Mode)

> OpenVidu PRO can be executed locally in evaluation mode for free for development and testing purposes.
> Some limits apply: max 8 Participants across all Rooms and max 5 minutes duration per Room.

### Install OpenVidu PRO

#### Windows

```sh
git clone https://github.com/OpenVidu/openvidu-local-deployment
cd openvidu-local-deployment/pro
.\configure_lan_private_ip_windows.bat
```

#### Mac

```sh
git clone https://github.com/OpenVidu/openvidu-local-deployment
cd openvidu-local-deployment/pro
./configure_lan_private_ip_mac.sh
```

#### Linux

```sh
git clone https://github.com/OpenVidu/openvidu-local-deployment
cd openvidu-local-deployment/pro
./configure_lan_private_ip_linux.sh
```

### Run OpenVidu PRO

**Chạy toàn bộ hệ thống:**
```sh
docker compose up -d
```

**Chạy bộ khung tối giản (Khuyên dùng cho DEV):**
```sh
docker compose up -d redis mongo minio openvidu caddy-proxy operator
```

**Dừng hệ thống:**
```sh
docker compose down
```
