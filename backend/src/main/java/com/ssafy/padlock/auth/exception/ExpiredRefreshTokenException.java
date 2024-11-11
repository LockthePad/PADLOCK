package com.ssafy.padlock.auth.exception;

import com.ssafy.padlock.common.exception.ErrorCode;
import com.ssafy.padlock.common.exception.PadlockException;

public class ExpiredRefreshTokenException extends PadlockException {
    public ExpiredRefreshTokenException(String message) {
        super(ErrorCode.EXPIRED_REFRESH_TOKEN, message);
    }
}
