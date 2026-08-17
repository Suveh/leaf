package com.leaf.backend.dto;

import java.time.LocalDate;

import com.leaf.backend.entity.ReminderType;

import jakarta.validation.constraints.NotNull;

public record ReminderRequest(
        @NotNull ReminderType type,
        @NotNull LocalDate dueDate,
        @NotNull Boolean completed) {
}
