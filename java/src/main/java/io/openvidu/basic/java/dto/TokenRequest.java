package io.openvidu.basic.java.dto;

/**
 * DTO cho request tạo token
 */
public class TokenRequest {
    private String roomName;
    private String participantName;

    // Constructors
    public TokenRequest() {
    }

    public TokenRequest(String roomName, String participantName) {
        this.roomName = roomName;
        this.participantName = participantName;
    }

    // Getters and Setters
    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getParticipantName() {
        return participantName;
    }

    public void setParticipantName(String participantName) {
        this.participantName = participantName;
    }

    @Override
    public String toString() {
        return "TokenRequest{" +
                "roomName='" + roomName + '\'' +
                ", participantName='" + participantName + '\'' +
                '}';
    }
}
