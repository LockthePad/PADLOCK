package com.ssafy.padlock.common.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authorization.AuthorizationDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(PadlockException.class)
    public ResponseEntity<ErrorResponse> handlePadlockException(PadlockException exception) {
        ErrorResponse response = new ErrorResponse(exception.getCode(), exception.getMessage());
        log.error("PadlockException", exception);
        return new ResponseEntity<>(response, exception.getStatus());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(MethodArgumentNotValidException exception) {
        ErrorResponse response = new ErrorResponse(ErrorCode.INVALID_REQUEST_PARAMS.getCode(), errors(exception));
        log.error("MethodArgumentNotValidException", exception);
        return new ResponseEntity<>(response, ErrorCode.INVALID_REQUEST_PARAMS.getStatus());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(IllegalArgumentException exception) {
        ErrorResponse response = new ErrorResponse(ErrorCode.ILLEGAL_ARGUMENT.getCode(), exception.getMessage());
        log.error("IllegalArgumentException", exception);
        return new ResponseEntity<>(response, ErrorCode.ILLEGAL_ARGUMENT.getStatus());
    }

    @ExceptionHandler(AuthorizationDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDeniedException(AuthorizationDeniedException exception) {
        ErrorResponse response = new ErrorResponse(ErrorCode.ACCESS_DENIED.getCode(), exception.getMessage());
        log.error("AuthorizationDeniedException", exception);
        return new ResponseEntity<>(response, ErrorCode.ACCESS_DENIED.getStatus());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception exception) {
        ErrorResponse response = new ErrorResponse(ErrorCode.INTERNAL_SERVER_ERROR.getCode(), exception.getMessage());
        log.error("Exception", exception);
        return new ResponseEntity<>(response, ErrorCode.INTERNAL_SERVER_ERROR.getStatus());
    }

    private String errors(MethodArgumentNotValidException exception) {
        return exception.getBindingResult()
                .getAllErrors()
                .stream()
                .map(error -> field(error) + ": " + message(error))
                .collect(Collectors.joining(", "));
    }

    private String field(ObjectError error) {
        return ((FieldError) error).getField();
    }

    private String message(ObjectError error) {
        return error.getDefaultMessage();
    }
}
