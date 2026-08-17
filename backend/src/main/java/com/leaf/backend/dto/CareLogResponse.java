package com.leaf.backend.dto;

import java.time.Instant;

import com.leaf.backend.entity.CareLog;

public record CareLogResponse(
        Long id,
        Long plantId,
        String note,
        String photoUrl,
        Instant loggedAt) {

    public static CareLogResponse from(CareLog careLog) {
        return new CareLogResponse(
                careLog.getId(),
                careLog.getPlant().getId(),
                careLog.getNote(),
                careLog.getPhotoUrl(),
                careLog.getLoggedAt());
    }
}
