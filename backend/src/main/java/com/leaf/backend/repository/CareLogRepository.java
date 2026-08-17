package com.leaf.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.leaf.backend.entity.CareLog;

public interface CareLogRepository extends JpaRepository<CareLog, Long> {

    List<CareLog> findByPlantIdOrderByLoggedAtDesc(Long plantId);
}
