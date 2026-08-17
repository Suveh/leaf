package com.leaf.backend.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.leaf.backend.entity.Reminder;
import com.leaf.backend.exception.ResourceNotFoundException;
import com.leaf.backend.repository.ReminderRepository;

@Controller
public class AdminReminderController {

    private final ReminderRepository reminderRepository;

    public AdminReminderController(ReminderRepository reminderRepository) {
        this.reminderRepository = reminderRepository;
    }

    @PostMapping("/admin/reminders/{id}/delete")
    public String delete(@PathVariable Long id) {
        Reminder reminder = reminderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reminder " + id + " not found"));
        Long plantId = reminder.getPlant().getId();
        reminderRepository.delete(reminder);
        return "redirect:/admin/plants/" + plantId;
    }
}
