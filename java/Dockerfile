# ==========================================
# DOCKERFILE CHO BACKEND (Spring Boot)
# ==========================================

# Stage 1: Build application
FROM maven:3.9-eclipse-temurin-17-alpine AS build

# Set working directory
WORKDIR /app

# Copy pom.xml và download dependencies trước (tận dụng Docker cache)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build application (skip tests để build nhanh hơn)
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine

# Metadata
LABEL maintainer="your-email@example.com"
LABEL description="Meeting Backend API - Spring Boot Application"

# Tạo user non-root để chạy app (bảo mật)
RUN addgroup -S spring && adduser -S spring -G spring

# Set working directory
WORKDIR /app

# Copy JAR file từ build stage
COPY --from=build /app/target/*.jar app.jar

# Chuyển quyền sở hữu cho user spring
RUN chown -R spring:spring /app

# Switch sang user non-root
USER spring

# Expose port (Backend chạy ở port 6080)
EXPOSE 6080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:6080/actuator/health || exit 1

# Environment variables (có thể override khi chạy container)
ENV JAVA_OPTS="-Xmx512m -Xms256m"
ENV LIVEKIT_API_KEY=""
ENV LIVEKIT_API_SECRET=""

# Run application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
