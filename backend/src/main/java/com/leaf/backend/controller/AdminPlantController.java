package com.leaf.backend.controller;

import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.leaf.backend.dto.PlantFormModel;
import com.leaf.backend.entity.Plant;
import com.leaf.backend.repository.CareLogRepository;
import com.leaf.backend.repository.PlantRepository;
import com.leaf.backend.repository.ReminderRepository;
import com.leaf.backend.service.PlantFinder;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/admin/plants")
public class AdminPlantController {

    private final PlantRepository plantRepository;
    private final CareLogRepository careLogRepository;
    private final ReminderRepository reminderRepository;
    private final PlantFinder plantFinder;

    public AdminPlantController(
            PlantRepository plantRepository,
            CareLogRepository careLogRepository,
            ReminderRepository reminderRepository,
            PlantFinder plantFinder) {
        this.plantRepository = plantRepository;
        this.careLogRepository = careLogRepository;
        this.reminderRepository = reminderRepository;
        this.plantFinder = plantFinder;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("plants", plantRepository.findAll(Sort.by("name")));
        return "admin/plants/list";
    }

    @GetMapping("/new")
    public String newForm(Model model) {
        model.addAttribute("plantForm", new PlantFormModel());
        model.addAttribute("formAction", "/admin/plants");
        model.addAttribute("pageTitle", "Add Plant");
        return "admin/plants/form";
    }

    @PostMapping
    public String create(@Valid @ModelAttribute("plantForm") PlantFormModel form, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("formAction", "/admin/plants");
            model.addAttribute("pageTitle", "Add Plant");
            return "admin/plants/form";
        }
        Plant plant = new Plant();
        applyForm(plant, form);
        plantRepository.save(plant);
        return "redirect:/admin/plants";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        Plant plant = plantFinder.getOrThrow(id);
        model.addAttribute("plantForm", PlantFormModel.from(plant));
        model.addAttribute("formAction", "/admin/plants/" + id + "/edit");
        model.addAttribute("pageTitle", "Edit Plant");
        return "admin/plants/form";
    }

    @PostMapping("/{id}/edit")
    public String update(
            @PathVariable Long id, @Valid @ModelAttribute("plantForm") PlantFormModel form, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("formAction", "/admin/plants/" + id + "/edit");
            model.addAttribute("pageTitle", "Edit Plant");
            return "admin/plants/form";
        }
        Plant plant = plantFinder.getOrThrow(id);
        applyForm(plant, form);
        plantRepository.save(plant);
        return "redirect:/admin/plants";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        Plant plant = plantFinder.getOrThrow(id);
        plantRepository.delete(plant);
        return "redirect:/admin/plants";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        Plant plant = plantFinder.getOrThrow(id);
        model.addAttribute("plant", plant);
        model.addAttribute("careLogs", careLogRepository.findByPlantIdOrderByLoggedAtDesc(id));
        model.addAttribute("reminders", reminderRepository.findByPlantIdOrderByDueDateAsc(id));
        return "admin/plants/detail";
    }

    private void applyForm(Plant plant, PlantFormModel form) {
        plant.setName(form.getName());
        plant.setSpecies(form.getSpecies());
        plant.setPhotoUrl(form.getPhotoUrl());
        plant.setWateringFrequencyDays(form.getWateringFrequencyDays());
        plant.setLastWateredDate(form.getLastWateredDate());
    }
}
