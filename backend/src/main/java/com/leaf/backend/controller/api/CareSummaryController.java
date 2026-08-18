package com.leaf.backend.controller.api;

import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.leaf.backend.dto.CareSummaryResponse;
import com.leaf.backend.entity.CareLog;
import com.leaf.backend.entity.Plant;
import com.leaf.backend.repository.CareLogRepository;
import com.leaf.backend.service.CareSummaryService;
import com.leaf.backend.service.PlantFinder;

@RestController
public class CareSummaryController {

    private static final int RECENT_LOG_COUNT = 5;

    private final PlantFinder plantFinder;
    private final CareLogRepository careLogRepository;
    private final CareSummaryService careSummaryService;

    public CareSummaryController(
            PlantFinder plantFinder, CareLogRepository careLogRepository, CareSummaryService careSummaryService) {
        this.plantFinder = plantFinder;
        this.careLogRepository = careLogRepository;
        this.careSummaryService = careSummaryService;
    }

    @GetMapping("/api/plants/{id}/care-summary")
    public CareSummaryResponse getCareSummary(@PathVariable Long id) {
        Plant plant = plantFinder.getOrThrow(id);
        List<CareLog> recentLogs = careLogRepository.findByPlantIdOrderByLoggedAtDesc(
                id, PageRequest.of(0, RECENT_LOG_COUNT, Sort.unsorted()));
        String summary = careSummaryService.generateSummary(plant, recentLogs);
        return new CareSummaryResponse(id, summary);
    }
}
