package com.leaf.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.leaf.backend.entity.Plant;

public interface PlantRepository extends JpaRepository<Plant, Long> {
}
