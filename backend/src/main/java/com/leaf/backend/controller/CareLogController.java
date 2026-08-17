package com.leaf.backend.controller;

import java.net.URI;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.leaf.backend.dto.CareLogRequest;
import com.leaf.backend.dto.CareLogResponse;
import com.leaf.backend.entity.CareLog;
import com.leaf.backend.entity.Plant;
import com.leaf.backend.exception.ResourceNotFoundException;
import com.leaf.backend.repository.CareLogRepository;
import com.leaf.backend.service.PlantFinder;

import jakarta.validation.Valid;

@RestController
public class CareLogController {

    private final CareLogRepository careLogRepository;
    private final PlantFinder plantFinder;

    public CareLogController(CareLogRepository careLogRepository, PlantFinder plantFinder) {
        this.careLogRepository = careLogRepository;
        this.plantFinder = plantFinder;
    }

    @GetMapping("/api/plants/{plantId}/logs")
    public List<CareLogResponse> getByPlant(@PathVariable Long plantId) {
        plantFinder.getOrThrow(plantId);
        return careLogRepository.findByPlantIdOrderByLoggedAtDesc(plantId).stream()
                .map(CareLogResponse::from)
                .toList();
    }

    @PostMapping("/api/plants/{plantId}/logs")
    public ResponseEntity<CareLogResponse> create(@PathVariable Long plantId, @Valid @RequestBody CareLogRequest request) {
        Plant plant = plantFinder.getOrThrow(plantId);

        CareLog careLog = new CareLog();
        careLog.setPlant(plant);
        careLog.setNote(request.note());
        careLog.setPhotoUrl(request.photoUrl());
        careLog.setLoggedAt(request.loggedAt());

        CareLog saved = careLogRepository.save(careLog);
        return ResponseEntity.created(URI.create("/api/logs/" + saved.getId()))
                .body(CareLogResponse.from(saved));
    }

    @DeleteMapping("/api/logs/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        CareLog careLog = careLogRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Care log " + id + " not found"));
        careLogRepository.delete(careLog);
        return ResponseEntity.noContent().build();
    }
}
