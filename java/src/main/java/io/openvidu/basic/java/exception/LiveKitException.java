package io.openvidu.basic.java.exception;

/**
 * Custom exception cho các lỗi liên quan đến LiveKit
 */
public class LiveKitException extends RuntimeException {

    public LiveKitException(String message) {
        super(message);
    }

    public LiveKitException(String message, Throwable cause) {
        super(message, cause);
    }
}
