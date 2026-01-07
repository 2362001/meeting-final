package io.openvidu.basic.java.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import io.livekit.server.AccessToken;
import io.livekit.server.RoomJoin;
import io.livekit.server.RoomName;
import io.livekit.server.WebhookReceiver;
import io.openvidu.basic.java.dto.TokenRequest;
import io.openvidu.basic.java.service.LiveKitService;
import livekit.LivekitWebhook.WebhookEvent;

/**
 * Implementation của LiveKitService
 * Xử lý các nghiệp vụ liên quan đến LiveKit
 */
@Service
public class LiveKitServiceImpl implements LiveKitService {

    private static final Logger logger = LoggerFactory.getLogger(LiveKitServiceImpl.class);

    @Value("${livekit.api.key}")
    private String livekitApiKey;

    @Value("${livekit.api.secret}")
    private String livekitApiSecret;

    /**
     * Tạo JWT token để người dùng tham gia phòng họp
     */
    @Override
    public String createRoomToken(TokenRequest request) {
        // Validate input
        if (request.getRoomName() == null || request.getRoomName().trim().isEmpty()) {
            throw new IllegalArgumentException("roomName không được để trống");
        }
        if (request.getParticipantName() == null || request.getParticipantName().trim().isEmpty()) {
            throw new IllegalArgumentException("participantName không được để trống");
        }

        logger.info("Tạo token cho người dùng '{}' tham gia phòng '{}'",
                request.getParticipantName(), request.getRoomName());

        try {
            // Khởi tạo AccessToken với API credentials
            AccessToken token = new AccessToken(livekitApiKey, livekitApiSecret);

            // Set thông tin người dùng
            token.setName(request.getParticipantName()); // Tên hiển thị
            token.setIdentity(request.getParticipantName()); // ID duy nhất

            // Phân quyền: Cho phép join vào phòng cụ thể
            token.addGrants(new RoomJoin(true), new RoomName(request.getRoomName()));

            // Chuyển đổi thành JWT string
            String jwtToken = token.toJwt();

            logger.info("Tạo token thành công cho người dùng '{}'", request.getParticipantName());

            return jwtToken;

        } catch (Exception e) {
            logger.error("Lỗi khi tạo token cho người dùng '{}': {}",
                    request.getParticipantName(), e.getMessage(), e);
            throw new RuntimeException("Không thể tạo token: " + e.getMessage(), e);
        }
    }

    /**
     * Xử lý webhook event từ LiveKit Server
     */
    @Override
    public WebhookEvent processWebhook(String body, String authHeader) throws Exception {
        logger.info("Nhận webhook từ LiveKit Server");

        try {
            // Khởi tạo WebhookReceiver để xác thực
            WebhookReceiver webhookReceiver = new WebhookReceiver(livekitApiKey, livekitApiSecret);

            // Giải mã và xác thực webhook
            WebhookEvent event = webhookReceiver.receive(body, authHeader);

            logger.info("Webhook xác thực thành công - Event: {}", event.getEvent());
            logger.debug("Chi tiết webhook: {}", event.toString());

            // Xử lý các loại event khác nhau
            handleWebhookEvent(event);

            return event;

        } catch (Exception e) {
            logger.error("Lỗi xác thực webhook: {}", e.getMessage(), e);
            throw e;
        }
    }

    /**
     * Xử lý logic nghiệp vụ cho từng loại webhook event
     */
    private void handleWebhookEvent(WebhookEvent event) {
        switch (event.getEvent()) {
            case "participant_joined":
                logger.info("Người dùng tham gia phòng: Room={}, Participant={}",
                        event.getRoom().getName(),
                        event.getParticipant().getIdentity());
                // TODO: Có thể lưu vào database, gửi notification, etc.
                break;

            case "participant_left":
                logger.info("Người dùng rời phòng: Room={}, Participant={}",
                        event.getRoom().getName(),
                        event.getParticipant().getIdentity());
                // TODO: Cập nhật trạng thái, thống kê thời gian tham gia, etc.
                break;

            case "track_published":
                logger.info("Track được publish: Room={}, Participant={}, TrackType={}",
                        event.getRoom().getName(),
                        event.getParticipant().getIdentity(),
                        event.getTrack().getType());
                // TODO: Xử lý khi user bật camera/mic
                break;

            case "track_unpublished":
                logger.info("Track bị unpublish: Room={}, Participant={}",
                        event.getRoom().getName(),
                        event.getParticipant().getIdentity());
                // TODO: Xử lý khi user tắt camera/mic
                break;

            case "room_started":
                logger.info("Phòng họp bắt đầu: Room={}", event.getRoom().getName());
                // TODO: Ghi log thời gian bắt đầu meeting
                break;

            case "room_finished":
                logger.info("Phòng họp kết thúc: Room={}", event.getRoom().getName());
                // TODO: Tính toán thống kê, lưu báo cáo meeting
                break;

            default:
                logger.debug("Nhận được event khác: {}", event.getEvent());
                break;
        }
    }
}
