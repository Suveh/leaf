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
import org.springframework.web.bind.annotation.RestController;

import com.leaf.backend.dto.ReminderRequest;
import com.leaf.backend.dto.ReminderResponse;
import com.leaf.backend.entity.Plant;
import com.leaf.backend.entity.Reminder;
import com.leaf.backend.exception.ResourceNotFoundException;
import com.leaf.backend.repository.PlantRepository;
import com.leaf.backend.repository.ReminderRepository;

import jakarta.validation.Valid;

@RestController
public class ReminderController {

    private final ReminderRepository reminderRepository;
    private final PlantRepository plantRepository;

    public ReminderController(ReminderRepository reminderRepository, PlantRepository plantRepository) {
        this.reminderRepository = reminderRepository;
        this.plantRepository = plantRepository;
    }

    @GetMapping("/api/plants/{plantId}/reminders")
    public List<ReminderResponse> getByPlant(@PathVariable Long plantId) {
        requirePlant(plantId);
        return reminderRepository.findByPlantIdOrderByDueDateAsc(plantId).stream()
                .map(ReminderResponse::from)
                .toList();
    }

    @PostMapping("/api/plants/{plantId}/reminders")
    public ResponseEntity<ReminderResponse> create(@PathVariable Long plantId, @Valid @RequestBody ReminderRequest request) {
        Plant plant = requirePlant(plantId);

        Reminder reminder = new Reminder();
        reminder.setPlant(plant);
        applyRequest(reminder, request);

        Reminder saved = reminderRepository.save(reminder);
        return ResponseEntity.created(URI.create("/api/reminders/" + saved.getId()))
                .body(ReminderResponse.from(saved));
    }

    @PutMapping("/api/reminders/{id}")
    public ReminderResponse update(@PathVariable Long id, @Valid @RequestBody ReminderRequest request) {
        Reminder reminder = findReminderOrThrow(id);
        applyRequest(reminder, request);
        return ReminderResponse.from(reminderRepository.save(reminder));
    }

    @DeleteMapping("/api/reminders/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        Reminder reminder = findReminderOrThrow(id);
        reminderRepository.delete(reminder);
        return ResponseEntity.noContent().build();
    }

    private Reminder findReminderOrThrow(Long id) {
        return reminderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reminder " + id + " not found"));
    }

    private Plant requirePlant(Long plantId) {
        return plantRepository.findById(plantId)
                .orElseThrow(() -> new ResourceNotFoundException("Plant " + plantId + " not found"));
    }

    private void applyRequest(Reminder reminder, ReminderRequest request) {
        reminder.setType(request.type());
        reminder.setDueDate(request.dueDate());
        reminder.setCompleted(request.completed());
    }
}
