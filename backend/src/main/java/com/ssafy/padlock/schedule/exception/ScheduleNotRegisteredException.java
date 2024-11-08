package com.ssafy.padlock.schedule.exception;

import com.ssafy.padlock.common.exception.ErrorCode;
import com.ssafy.padlock.common.exception.PadlockException;

public class ScheduleNotRegisteredException extends PadlockException {
    public ScheduleNotRegisteredException(String message) {
        super(ErrorCode.SCHEDULE_NOT_REGISTERED, message);
    }
}
