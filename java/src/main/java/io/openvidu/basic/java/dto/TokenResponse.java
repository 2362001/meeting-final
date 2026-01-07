package io.openvidu.basic.java.dto;

/**
 * DTO cho response trả về token
 */
public class TokenResponse {
    private String token;

    // Constructors
    public TokenResponse() {
    }

    public TokenResponse(String token) {
        this.token = token;
    }

    // Getters and Setters
    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    @Override
    public String toString() {
        return "TokenResponse{" +
                "token='" + token + '\'' +
                '}';
    }
}
