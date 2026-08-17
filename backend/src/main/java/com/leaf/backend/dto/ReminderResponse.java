package com.leaf.backend.dto;

import java.time.LocalDate;

import com.leaf.backend.entity.Reminder;
import com.leaf.backend.entity.ReminderType;

public record ReminderResponse(
        Long id,
        Long plantId,
        ReminderType type,
        LocalDate dueDate,
        boolean completed) {

    public static ReminderResponse from(Reminder reminder) {
        return new ReminderResponse(
                reminder.getId(),
                reminder.getPlant().getId(),
                reminder.getType(),
                reminder.getDueDate(),
                reminder.isCompleted());
    }
}
