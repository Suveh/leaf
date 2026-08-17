package com.leaf.backend.dto;

import java.time.LocalDate;

import com.leaf.backend.entity.Plant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

// Plain JavaBean, not a record: Thymeleaf th:field binding needs getter/setter access.
public class PlantFormModel {

    @NotBlank
    private String name;

    private String species;

    private String photoUrl;

    @NotNull
    @Positive
    private Integer wateringFrequencyDays;

    private LocalDate lastWateredDate;

    public static PlantFormModel from(Plant plant) {
        PlantFormModel form = new PlantFormModel();
        form.setName(plant.getName());
        form.setSpecies(plant.getSpecies());
        form.setPhotoUrl(plant.getPhotoUrl());
        form.setWateringFrequencyDays(plant.getWateringFrequencyDays());
        form.setLastWateredDate(plant.getLastWateredDate());
        return form;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public Integer getWateringFrequencyDays() {
        return wateringFrequencyDays;
    }

    public void setWateringFrequencyDays(Integer wateringFrequencyDays) {
        this.wateringFrequencyDays = wateringFrequencyDays;
    }

    public LocalDate getLastWateredDate() {
        return lastWateredDate;
    }

    public void setLastWateredDate(LocalDate lastWateredDate) {
        this.lastWateredDate = lastWateredDate;
    }
}
