package com.leaf.backend.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.leaf.backend.entity.CareLog;
import com.leaf.backend.exception.ResourceNotFoundException;
import com.leaf.backend.repository.CareLogRepository;

@Controller
public class AdminCareLogController {

    private final CareLogRepository careLogRepository;

    public AdminCareLogController(CareLogRepository careLogRepository) {
        this.careLogRepository = careLogRepository;
    }

    @PostMapping("/admin/logs/{id}/delete")
    public String delete(@PathVariable Long id) {
        CareLog careLog = careLogRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Care log " + id + " not found"));
        Long plantId = careLog.getPlant().getId();
        careLogRepository.delete(careLog);
        return "redirect:/admin/plants/" + plantId;
    }
}
