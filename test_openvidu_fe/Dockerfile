# ==========================================
# DOCKERFILE CHO FRONTEND (Angular)
# ==========================================

# Stage 1: Build Angular application
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build Angular app cho production
RUN npm run build -- --configuration production

# Stage 2: Serve với Nginx
FROM nginx:1.25-alpine

# Metadata
LABEL maintainer="your-email@example.com"
LABEL description="Meeting Frontend - Angular Application"

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built app từ build stage
COPY --from=build /app/dist/basic-angular/browser /usr/share/nginx/html

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
