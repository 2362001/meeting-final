package io.openvidu.basic.java.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.openvidu.basic.java.dto.ErrorResponse;
import io.openvidu.basic.java.dto.TokenRequest;
import io.openvidu.basic.java.dto.TokenResponse;
import io.openvidu.basic.java.service.LiveKitService;
import livekit.LivekitWebhook.WebhookEvent;

/**
 * REST Controller xử lý các API liên quan đến LiveKit
 */
@CrossOrigin(origins = "*") // Cho phép CORS từ mọi nguồn (nên giới hạn trong production)
@RestController
@RequestMapping("/api/livekit")
public class LiveKitController {

    private static final Logger logger = LoggerFactory.getLogger(LiveKitController.class);

    @Autowired
    private LiveKitService liveKitService;

    /**
     * API tạo token để tham gia phòng họp
     * 
     * POST /api/livekit/token
     * Body: { "roomName": "room-123", "participantName": "User A" }
     * Response: { "token": "eyJhbGc..." }
     */
    @PostMapping("/token")
    public ResponseEntity<?> createToken(@RequestBody TokenRequest request) {
        logger.info("Nhận request tạo token: {}", request);

        try {
            // Gọi service để tạo token
            String token = liveKitService.createRoomToken(request);

            // Trả về response thành công
            return ResponseEntity.ok(new TokenResponse(token));

        } catch (IllegalArgumentException e) {
            // Lỗi validation
            logger.warn("Dữ liệu đầu vào không hợp lệ: {}", e.getMessage());
            return ResponseEntity
                    .badRequest()
                    .body(new ErrorResponse(e.getMessage()));

        } catch (Exception e) {
            // Lỗi hệ thống
            logger.error("Lỗi khi tạo token: {}", e.getMessage(), e);
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("Lỗi hệ thống: " + e.getMessage()));
        }
    }

    /**
     * API nhận webhook từ LiveKit Server
     * 
     * POST /api/livekit/webhook
     * Headers: Authorization: <signature>
     * Body: <webhook event JSON>
     */
    @PostMapping(value = "/webhook", consumes = "application/webhook+json")
    public ResponseEntity<String> receiveWebhook(
            @RequestHeader("Authorization") String authHeader,
            @RequestBody String body) {

        logger.info("Nhận webhook từ LiveKit Server");

        try {
            // Gọi service để xử lý webhook
            WebhookEvent event = liveKitService.processWebhook(body, authHeader);

            logger.info("Xử lý webhook thành công - Event type: {}", event.getEvent());

            return ResponseEntity.ok("ok");

        } catch (Exception e) {
            // Lỗi xác thực hoặc xử lý webhook
            logger.error("Lỗi xử lý webhook: {}", e.getMessage(), e);
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body("Webhook verification failed");
        }
    }
}
