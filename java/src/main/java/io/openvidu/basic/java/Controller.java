package io.openvidu.basic.java;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import io.livekit.server.AccessToken;
import io.livekit.server.RoomJoin;
import io.livekit.server.RoomName;
import io.livekit.server.WebhookReceiver;
import livekit.LivekitWebhook.WebhookEvent;

/**
 * Controller xử lý các yêu cầu liên quan đến OpenVidu/LiveKit.
 * Bao gồm cấp phát Token cho Client và tiếp nhận Webhook từ Server.
 */
@CrossOrigin(origins = "*") // Cho phép mọi nguồn (Origin) truy cập API này (CORS)
@RestController
public class Controller {

	// Lấy API KEY từ tệp cấu hình (application.yml)
	@Value("${livekit.api.key}")
	private String LIVEKIT_API_KEY;

	// Lấy API SECRET từ tệp cấu hình (application.yml)
	@Value("${livekit.api.secret}")
	private String LIVEKIT_API_SECRET;

	/**
	 * API cấp phát Token để người dùng tham gia phòng họp.
	 * 
	 * @param params JSON object chứa roomName (tên phòng) và participantName (tên
	 *               người dùng)
	 * @return JSON object chứa token JWT dùng để kết nối tới LiveKit Server
	 */
	@PostMapping(value = "/token")
	public ResponseEntity<Map<String, String>> createToken(@RequestBody Map<String, String> params) {
		String roomName = params.get("roomName");
		String participantName = params.get("participantName");

		// Kiểm tra dữ liệu đầu vào
		if (roomName == null || participantName == null) {
			return ResponseEntity.badRequest()
					.body(Map.of("errorMessage", "roomName and participantName are required"));
		}

		// Khởi tạo AccessToken với thông tin định danh
		AccessToken token = new AccessToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET);
		token.setName(participantName); // Tên hiển thị của người dùng
		token.setIdentity(participantName); // ID duy nhất của người dùng trong hệ thống LiveKit

		// Phân quyền: Cho phép người dùng tham gia (Join) vào phòng cụ thể (RoomName)
		token.addGrants(new RoomJoin(true), new RoomName(roomName));

		// Chuyển đổi đối tượng token thành chuỗi JWT để gửi về cho Client
		return ResponseEntity.ok(Map.of("token", token.toJwt()));
	}

	/**
	 * API tiếp nhận Webhook từ OpenVidu/LiveKit Server.
	 * Dùng để theo dõi các sự kiện như: người dùng tham gia/rời phòng, bắt đầu ghi
	 * hình, v.v.
	 * 
	 * @param authHeader Tiêu đề Authorization chứa chữ ký xác thực từ Server
	 * @param body       Nội dung sự kiện dưới dạng chuỗi JSON
	 */
	@PostMapping(value = "/livekit/webhook", consumes = "application/webhook+json")
	public ResponseEntity<String> receiveWebhook(@RequestHeader("Authorization") String authHeader,
			@RequestBody String body) {
		// Khởi tạo bộ thu Webhook để kiểm tra tính hợp lệ của dữ liệu dựa trên Secret
		// Key
		WebhookReceiver webhookReceiver = new WebhookReceiver(LIVEKIT_API_KEY, LIVEKIT_API_SECRET);
		try {
			// Giải mã và xác thực sự kiện
			WebhookEvent event = webhookReceiver.receive(body, authHeader);
			System.out.println("LiveKit Webhook nhận được sự kiện: " + event.toString());

			// Tại đây bạn có thể thêm logic xử lý riêng (vd: lưu log vào database, thông
			// báo cho user khác...)

		} catch (Exception e) {
			// Trường hợp chữ ký không khớp hoặc dữ liệu bị sai lệch
			System.err.println("Lỗi xác thực sự kiện Webhook: " + e.getMessage());
		}

		return ResponseEntity.ok("ok");
	}

}
