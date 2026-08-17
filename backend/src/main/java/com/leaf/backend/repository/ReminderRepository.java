package com.leaf.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.leaf.backend.entity.Reminder;

public interface ReminderRepository extends JpaRepository<Reminder, Long> {

    List<Reminder> findByPlantIdOrderByDueDateAsc(Long plantId);
}
