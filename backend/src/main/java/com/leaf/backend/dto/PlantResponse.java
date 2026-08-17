package com.leaf.backend.dto;

import java.time.Instant;
import java.time.LocalDate;

import com.leaf.backend.entity.Plant;

public record PlantResponse(
        Long id,
        String name,
        String species,
        String photoUrl,
        Integer wateringFrequencyDays,
        LocalDate lastWateredDate,
        Instant createdAt) {

    public static PlantResponse from(Plant plant) {
        return new PlantResponse(
                plant.getId(),
                plant.getName(),
                plant.getSpecies(),
                plant.getPhotoUrl(),
                plant.getWateringFrequencyDays(),
                plant.getLastWateredDate(),
                plant.getCreatedAt());
    }
}
