package io.openvidu.basic.java.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;

/**
 * Configuration class cho LiveKit
 * Kiểm tra và validate các cấu hình khi khởi động ứng dụng
 */
@Configuration
public class LiveKitConfig {

    @Value("${livekit.api.key}")
    private String apiKey;

    @Value("${livekit.api.secret}")
    private String apiSecret;

    @Value("${server.port}")
    private String serverPort;

    /**
     * Kiểm tra cấu hình khi ứng dụng khởi động
     */
    @PostConstruct
    public void validateConfig() {
        System.out.println("=".repeat(60));
        System.out.println("LiveKit Configuration:");
        System.out.println("  API Key: " + (apiKey != null && !apiKey.isEmpty() ? "✓ Configured" : "✗ Missing"));
        System.out
                .println("  API Secret: " + (apiSecret != null && !apiSecret.isEmpty() ? "✓ Configured" : "✗ Missing"));
        System.out.println("  Server Port: " + serverPort);
        System.out.println("=".repeat(60));

        if (apiKey == null || apiKey.isEmpty() || apiKey.equals("devkey")) {
            System.err.println("⚠ WARNING: Đang sử dụng API Key mặc định. Hãy set biến môi trường LIVEKIT_API_KEY");
        }

        if (apiSecret == null || apiSecret.isEmpty() || apiSecret.equals("secret")) {
            System.err
                    .println("⚠ WARNING: Đang sử dụng API Secret mặc định. Hãy set biến môi trường LIVEKIT_API_SECRET");
        }
    }

    // Getters
    public String getApiKey() {
        return apiKey;
    }

    public String getApiSecret() {
        return apiSecret;
    }

    public String getServerPort() {
        return serverPort;
    }
}
