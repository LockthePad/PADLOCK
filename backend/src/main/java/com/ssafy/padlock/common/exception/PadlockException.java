package com.ssafy.padlock.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class PadlockException extends RuntimeException {
    private final String code;
    private final String message;
    private final HttpStatus status;

    public PadlockException(ErrorCode errorCode) {
        this(errorCode, errorCode.getMessage());
    }

    public PadlockException(ErrorCode errorCode, String message) {
        this(null, errorCode, message);
    }

    public PadlockException(Throwable cause, ErrorCode errorCode) {
        this(cause, errorCode.getCode(), errorCode.getMessage(), errorCode.getStatus());
    }

    public PadlockException(Throwable cause, ErrorCode errorCode, String message) {
        this(cause, errorCode.getCode(), message, errorCode.getStatus());
    }

    public PadlockException(Throwable cause, String code, String message, HttpStatus status) {
        super(message, cause);
        this.code = code;
        this.message = message;
        this.status = status;
    }
}
