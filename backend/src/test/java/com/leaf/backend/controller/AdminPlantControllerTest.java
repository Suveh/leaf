package com.leaf.backend.controller;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class AdminPlantControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    private long createPlantViaForm(String name) throws Exception {
        mockMvc.perform(post("/admin/plants")
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                        .param("name", name)
                        .param("wateringFrequencyDays", "7"))
                .andExpect(status().is3xxRedirection());

        String listResponse = mockMvc.perform(get("/api/plants"))
                .andReturn().getResponse().getContentAsString();
        for (var node : objectMapper.readTree(listResponse)) {
            if (node.get("name").asText().equals(name)) {
                return node.get("id").asLong();
            }
        }
        throw new AssertionError("Plant \"" + name + "\" not found after creation");
    }

    @Test
    void listRendersEmptyState() throws Exception {
        mockMvc.perform(get("/admin/plants"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/plants/list"))
                .andExpect(content().string(containsString("No plants yet.")));
    }

    @Test
    void createViaFormThenAppearsInList() throws Exception {
        mockMvc.perform(post("/admin/plants")
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                        .param("name", "Monstera")
                        .param("species", "Monstera deliciosa")
                        .param("wateringFrequencyDays", "7"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/plants"));

        mockMvc.perform(get("/admin/plants"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Monstera")));
    }

    @Test
    void createWithBlankNameReRendersFormWithError() throws Exception {
        mockMvc.perform(post("/admin/plants")
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                        .param("name", "")
                        .param("wateringFrequencyDays", "7"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/plants/form"))
                .andExpect(content().string(containsString("field-error")));
    }

    @Test
    void detailForUnknownPlantRendersHtmlNotFound() throws Exception {
        mockMvc.perform(get("/admin/plants/999999"))
                .andExpect(status().isNotFound())
                .andExpect(view().name("admin/error"))
                .andExpect(content().string(containsString("not found")));
    }

    @Test
    void detailShowsCareLogsAndReminders() throws Exception {
        long plantId = createPlantViaForm("Fern");

        mockMvc.perform(post("/api/plants/" + plantId + "/logs")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"note\":\"Misted the leaves\"}"))
                .andExpect(status().isCreated());

        mockMvc.perform(post("/api/plants/" + plantId + "/reminders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"WATERING\",\"dueDate\":\"2026-09-01\",\"completed\":false}"))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/admin/plants/" + plantId))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Misted the leaves")))
                .andExpect(content().string(containsString("WATERING")));
    }

    @Test
    void deletingPlantCascadesAndRedirectsToList() throws Exception {
        long plantId = createPlantViaForm("Snake Plant");

        mockMvc.perform(post("/api/plants/" + plantId + "/logs")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"note\":\"Repotted\"}"))
                .andExpect(status().isCreated());

        mockMvc.perform(post("/admin/plants/" + plantId + "/delete"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/plants"));

        mockMvc.perform(get("/admin/plants/" + plantId))
                .andExpect(status().isNotFound());
    }
}
