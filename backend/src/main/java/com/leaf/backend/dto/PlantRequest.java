package com.leaf.backend.dto;

import java.time.LocalDate;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record PlantRequest(
        @NotBlank String name,
        String species,
        String photoUrl,
        @NotNull @Positive Integer wateringFrequencyDays,
        LocalDate lastWateredDate) {
}
