package com.ssafy.padlock.schedule.exception;

import com.ssafy.padlock.common.exception.ErrorCode;
import com.ssafy.padlock.common.exception.PadlockException;

public class InvalidPeriodException extends PadlockException {
    public InvalidPeriodException(String message) {
        super(ErrorCode.SCHEDULE_LIMIT_EXCEEDED, message);
    }
}
