package io.openvidu.basic.java.service;

import io.openvidu.basic.java.dto.TokenRequest;
import livekit.LivekitWebhook.WebhookEvent;

/**
 * Service interface cho các nghiệp vụ liên quan đến LiveKit
 */
public interface LiveKitService {

    /**
     * Tạo JWT token để người dùng tham gia phòng họp
     * 
     * @param request TokenRequest chứa roomName và participantName
     * @return JWT token string
     * @throws IllegalArgumentException nếu dữ liệu đầu vào không hợp lệ
     */
    String createRoomToken(TokenRequest request);

    /**
     * Xử lý webhook event từ LiveKit Server
     * 
     * @param body       Nội dung webhook dưới dạng JSON string
     * @param authHeader Authorization header chứa chữ ký xác thực
     * @return WebhookEvent đã được parse và xác thực
     * @throws Exception nếu xác thực thất bại hoặc dữ liệu không hợp lệ
     */
    WebhookEvent processWebhook(String body, String authHeader) throws Exception;
}
