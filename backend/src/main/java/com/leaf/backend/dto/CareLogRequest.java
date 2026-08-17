package com.leaf.backend.dto;

import java.time.Instant;

import jakarta.validation.constraints.NotBlank;

public record CareLogRequest(
        @NotBlank String note,
        String photoUrl,
        Instant loggedAt) {
}
