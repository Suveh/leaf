package com.leaf.backend.service;

import org.springframework.stereotype.Component;

import com.leaf.backend.entity.Plant;
import com.leaf.backend.exception.ResourceNotFoundException;
import com.leaf.backend.repository.PlantRepository;

@Component
public class PlantFinder {

    private final PlantRepository plantRepository;

    public PlantFinder(PlantRepository plantRepository) {
        this.plantRepository = plantRepository;
    }

    public Plant getOrThrow(Long id) {
        return plantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Plant " + id + " not found"));
    }
}
