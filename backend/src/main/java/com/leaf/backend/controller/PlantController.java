package com.leaf.backend.controller;

import java.net.URI;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.leaf.backend.dto.PlantRequest;
import com.leaf.backend.dto.PlantResponse;
import com.leaf.backend.entity.Plant;
import com.leaf.backend.repository.PlantRepository;
import com.leaf.backend.service.PlantFinder;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/plants")
public class PlantController {

    private final PlantRepository plantRepository;
    private final PlantFinder plantFinder;

    public PlantController(PlantRepository plantRepository, PlantFinder plantFinder) {
        this.plantRepository = plantRepository;
        this.plantFinder = plantFinder;
    }

    @GetMapping
    public List<PlantResponse> getAll() {
        return plantRepository.findAll().stream()
                .map(PlantResponse::from)
                .toList();
    }

    @GetMapping("/{id}")
    public PlantResponse getById(@PathVariable Long id) {
        return PlantResponse.from(plantFinder.getOrThrow(id));
    }

    @PostMapping
    public ResponseEntity<PlantResponse> create(@Valid @RequestBody PlantRequest request) {
        Plant plant = new Plant();
        applyRequest(plant, request);
        Plant saved = plantRepository.save(plant);
        return ResponseEntity.created(URI.create("/api/plants/" + saved.getId()))
                .body(PlantResponse.from(saved));
    }

    @PutMapping("/{id}")
    public PlantResponse update(@PathVariable Long id, @Valid @RequestBody PlantRequest request) {
        Plant plant = plantFinder.getOrThrow(id);
        applyRequest(plant, request);
        return PlantResponse.from(plantRepository.save(plant));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        Plant plant = plantFinder.getOrThrow(id);
        plantRepository.delete(plant);
        return ResponseEntity.noContent().build();
    }

    private void applyRequest(Plant plant, PlantRequest request) {
        plant.setName(request.name());
        plant.setSpecies(request.species());
        plant.setPhotoUrl(request.photoUrl());
        plant.setWateringFrequencyDays(request.wateringFrequencyDays());
        plant.setLastWateredDate(request.lastWateredDate());
    }
}
