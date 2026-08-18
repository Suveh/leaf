package com.leaf.backend.exception;

public class AiUnavailableException extends RuntimeException {

    public AiUnavailableException(String message, Throwable cause) {
        super(message, cause);
    }
}
