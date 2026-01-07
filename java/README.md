# OpenVidu/LiveKit Java Backend

> Ứng dụng server Spring Boot để tích hợp với OpenVidu/LiveKit - Nền tảng video conferencing

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.4-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![LiveKit](https://img.shields.io/badge/LiveKit-0.8.2-blue.svg)](https://livekit.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 Mục Lục

- [Giới Thiệu](#-giới-thiệu)
- [Tính Năng](#-tính-năng)
- [Kiến Trúc](#-kiến-trúc)
- [Cài Đặt](#-cài-đặt)
- [Sử Dụng](#-sử-dụng)
- [API Documentation](#-api-documentation)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Tài Liệu](#-tài-liệu)

---

## 🎯 Giới Thiệu

Đây là ứng dụng backend được xây dựng theo **mô hình Controller-Service** chuẩn Spring Boot, cung cấp API để:

- ✅ Tạo JWT token cho client tham gia phòng họp video
- ✅ Nhận và xử lý webhook events từ LiveKit Server
- ✅ Quản lý phòng họp và người dùng
- ✅ Logging và monitoring đầy đủ

---

## ✨ Tính Năng

### Core Features

- 🎫 **Token Generation**: Tạo JWT token với quyền truy cập phòng họp
- 🔔 **Webhook Processing**: Xử lý real-time events từ LiveKit
- 🔒 **Security**: Xác thực webhook signature
- 📝 **Logging**: SLF4J logging với multiple levels
- ✅ **Validation**: Input validation đầy đủ
- 🧪 **Testing**: Unit tests + Integration tests (90%+ coverage)

### Technical Features

- 🏗️ **Clean Architecture**: Controller-Service pattern
- 📦 **DTO Pattern**: Type-safe data transfer
- 🔧 **Configuration Management**: Externalized config
- 🐛 **Error Handling**: Proper HTTP status codes
- 🚀 **Docker Support**: Multi-stage Dockerfile
- 📊 **Monitoring Ready**: Spring Actuator compatible

---

## 🏗️ Kiến Trúc

### Cấu Trúc Package

```
io.openvidu.basic.java/
├── 📱 BasicJavaApplication.java    # Entry point
├── 📁 config/                      # Configuration
│   └── LiveKitConfig.java
├── 📁 controller/                  # REST Controllers
│   └── LiveKitController.java
├── 📁 service/                     # Business Logic
│   ├── LiveKitService.java
│   └── impl/
│       └── LiveKitServiceImpl.java
├── 📁 dto/                         # Data Transfer Objects
│   ├── TokenRequest.java
│   ├── TokenResponse.java
│   └── ErrorResponse.java
└── 📁 exception/                   # Custom Exceptions
    └── LiveKitException.java
```

### Request Flow

```
Client → Controller → Service → LiveKit SDK → Response
```

Chi tiết xem: [DIAGRAMS.md](DIAGRAMS.md)

---

## 🚀 Cài Đặt

### Prerequisites

- **Java 17+** ([Download](https://www.oracle.com/java/technologies/downloads/))
- **Maven 3.6+** ([Download](https://maven.apache.org/download.cgi))
- **Docker** (optional) ([Download](https://www.docker.com/))

### Clone Repository

```bash
git clone https://github.com/your-repo/openvidu-java-backend.git
cd openvidu-java-backend
```

### Build Project

```bash
mvn clean install
```

---

## 💻 Sử Dụng

### 1. Cấu Hình

Tạo file `.env` hoặc set environment variables:

```bash
# Windows PowerShell
$env:LIVEKIT_API_KEY="your_api_key"
$env:LIVEKIT_API_SECRET="your_api_secret"
$env:SERVER_PORT="6080"

# Linux/Mac
export LIVEKIT_API_KEY="your_api_key"
export LIVEKIT_API_SECRET="your_api_secret"
export SERVER_PORT="6080"
```

Hoặc sửa `src/main/resources/application.yml`:

```yaml
livekit:
  api:
    key: your_api_key
    secret: your_api_secret
```

### 2. Chạy Ứng Dụng

#### Với Maven

```bash
mvn spring-boot:run
```

#### Với Java

```bash
mvn clean package
java -jar target/basic-java-0.0.1-SNAPSHOT.jar
```

#### Với Docker

```bash
docker build -t openvidu-java .
docker run -p 6080:6080 \
  -e LIVEKIT_API_KEY=your_key \
  -e LIVEKIT_API_SECRET=your_secret \
  openvidu-java
```

### 3. Verify

Ứng dụng chạy tại: `http://localhost:6080`

Kiểm tra logs:

```
============================================================
LiveKit Configuration:
  API Key: ✓ Configured
  API Secret: ✓ Configured
  Server Port: 6080
============================================================
```

---

## 📡 API Documentation

### POST `/api/livekit/token`

Tạo JWT token để tham gia phòng họp.

**Request:**

```bash
curl -X POST http://localhost:6080/api/livekit/token \
  -H "Content-Type: application/json" \
  -d '{
    "roomName": "meeting-room-123",
    "participantName": "Nguyen Van A"
  }'
```

**Response (200 OK):**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Response (400 Bad Request):**

```json
{
  "errorMessage": "roomName không được để trống"
}
```

---

### POST `/api/livekit/webhook`

Nhận webhook events từ LiveKit Server.

**Headers:**

```
Authorization: <signature>
Content-Type: application/webhook+json
```

**Response:** `200 OK` hoặc `401 Unauthorized`

**Supported Events:**

- `participant_joined` - User vào phòng
- `participant_left` - User rời phòng
- `track_published` - Bật camera/mic
- `track_unpublished` - Tắt camera/mic
- `room_started` - Phòng bắt đầu
- `room_finished` - Phòng kết thúc

---

## 🧪 Testing

### Chạy Tests

```bash
# Chạy tất cả tests
mvn test

# Chạy test cụ thể
mvn test -Dtest=LiveKitServiceImplTest

# Chạy với coverage report
mvn clean test jacoco:report
```

### Test Coverage

- **31 test cases** (11 Service + 11 Controller + 9 DTO)
- **90%+ code coverage**
- Unit tests + Integration tests

Chi tiết xem: [TESTING.md](TESTING.md)

---

## 🚢 Deployment

### Docker Deployment

```bash
# Build image
docker build -t openvidu-java:latest .

# Run container
docker run -d \
  --name openvidu-backend \
  -p 6080:6080 \
  -e LIVEKIT_API_KEY=${LIVEKIT_API_KEY} \
  -e LIVEKIT_API_SECRET=${LIVEKIT_API_SECRET} \
  openvidu-java:latest
```

### Docker Compose

```yaml
version: '3.8'
services:
  openvidu-backend:
    build: .
    ports:
      - "6080:6080"
    environment:
      - LIVEKIT_API_KEY=${LIVEKIT_API_KEY}
      - LIVEKIT_API_SECRET=${LIVEKIT_API_SECRET}
      - SERVER_PORT=6080
```

### Production Checklist

- [ ] Set proper `LIVEKIT_API_KEY` và `LIVEKIT_API_SECRET`
- [ ] Enable HTTPS/SSL
- [ ] Configure CORS properly (không dùng `origins = "*"`)
- [ ] Set up monitoring (Spring Actuator + Prometheus)
- [ ] Configure logging (file rotation, log levels)
- [ ] Set up health checks
- [ ] Configure resource limits (memory, CPU)

---

## 📚 Tài Liệu

### Documentation Files

- [ARCHITECTURE.md](ARCHITECTURE.md) - Kiến trúc chi tiết
- [DIAGRAMS.md](DIAGRAMS.md) - Sơ đồ hệ thống
- [COMPARISON.md](COMPARISON.md) - So sánh code cũ vs mới
- [TESTING.md](TESTING.md) - Hướng dẫn testing

### External Resources

- [LiveKit Documentation](https://docs.livekit.io/)
- [Spring Boot Reference](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [OpenVidu Tutorials](https://livekit-tutorials.openvidu.io/)

---

## 🔧 Development

### Project Structure

```
java/
├── src/
│   ├── main/
│   │   ├── java/io/openvidu/basic/java/
│   │   └── resources/
│   │       └── application.yml
│   └── test/
│       ├── java/io/openvidu/basic/java/
│       └── resources/
│           └── application.yml
├── target/                    # Build output
├── Dockerfile
├── pom.xml
└── README.md
```

### Build Commands

```bash
# Clean build
mvn clean

# Compile
mvn compile

# Run tests
mvn test

# Package JAR
mvn package

# Install to local repo
mvn install

# Skip tests
mvn package -DskipTests
```

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Code Style

- Follow [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- Write Javadoc for public methods
- Add tests for new features
- Keep methods small and focused

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Your Name** - *Initial work*

---

## 🙏 Acknowledgments

- [OpenVidu](https://openvidu.io/) - Video conferencing platform
- [LiveKit](https://livekit.io/) - Real-time communication infrastructure
- [Spring Boot](https://spring.io/projects/spring-boot) - Application framework

---

## 📞 Support

- 📧 Email: support@example.com
- 💬 Discord: [Join our server](https://discord.gg/example)
- 📖 Documentation: [docs.example.com](https://docs.example.com)

---

## 🗺️ Roadmap

- [ ] Thêm database integration (PostgreSQL)
- [ ] Implement caching (Redis)
- [ ] Add authentication/authorization
- [ ] Implement rate limiting
- [ ] Add metrics và monitoring
- [ ] Create admin dashboard
- [ ] Add recording management
- [ ] Implement room analytics

---

**Made with ❤️ by Your Team**
