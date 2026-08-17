package com.leaf.backend.controller;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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
class CareLogAndReminderControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    private long createPlant(String name) throws Exception {
        String response = mockMvc.perform(post("/api/plants")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"" + name + "\",\"wateringFrequencyDays\":7}"))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(response).get("id").asLong();
    }

    @Test
    void careLogEndpoints404WhenPlantMissing() throws Exception {
        mockMvc.perform(get("/api/plants/999999/logs"))
                .andExpect(status().isNotFound());

        mockMvc.perform(post("/api/plants/999999/logs")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"note\":\"watered\"}"))
                .andExpect(status().isNotFound());
    }

    @Test
    void createAndDeleteCareLog() throws Exception {
        long plantId = createPlant("Monstera");

        String response = mockMvc.perform(post("/api/plants/" + plantId + "/logs")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"note\":\"Gave it a good soak\"}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.plantId", is((int) plantId)))
                .andExpect(jsonPath("$.note", is("Gave it a good soak")))
                .andReturn().getResponse().getContentAsString();
        long logId = objectMapper.readTree(response).get("id").asLong();

        mockMvc.perform(get("/api/plants/" + plantId + "/logs"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id", is((int) logId)));

        mockMvc.perform(delete("/api/logs/" + logId))
                .andExpect(status().isNoContent());

        mockMvc.perform(delete("/api/logs/" + logId))
                .andExpect(status().isNotFound());
    }

    @Test
    void createCareLogWithBlankNoteReturns400() throws Exception {
        long plantId = createPlant("Pothos");

        mockMvc.perform(post("/api/plants/" + plantId + "/logs")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"note\":\"\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void reminderEndpoints404WhenPlantMissing() throws Exception {
        mockMvc.perform(get("/api/plants/999999/reminders"))
                .andExpect(status().isNotFound());

        mockMvc.perform(post("/api/plants/999999/reminders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"WATERING\",\"dueDate\":\"2026-08-20\",\"completed\":false}"))
                .andExpect(status().isNotFound());
    }

    @Test
    void createUpdateAndDeleteReminder() throws Exception {
        long plantId = createPlant("Fern");

        String response = mockMvc.perform(post("/api/plants/" + plantId + "/reminders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"WATERING\",\"dueDate\":\"2026-08-20\",\"completed\":false}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.completed", is(false)))
                .andReturn().getResponse().getContentAsString();
        long reminderId = objectMapper.readTree(response).get("id").asLong();

        mockMvc.perform(put("/api/reminders/" + reminderId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"WATERING\",\"dueDate\":\"2026-08-20\",\"completed\":true}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed", is(true)));

        mockMvc.perform(delete("/api/reminders/" + reminderId))
                .andExpect(status().isNoContent());

        mockMvc.perform(put("/api/reminders/" + reminderId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"WATERING\",\"dueDate\":\"2026-08-20\",\"completed\":false}"))
                .andExpect(status().isNotFound());
    }

    @Test
    void createReminderWithMissingTypeReturns400() throws Exception {
        long plantId = createPlant("Cactus");

        mockMvc.perform(post("/api/plants/" + plantId + "/reminders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"dueDate\":\"2026-08-20\",\"completed\":false}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void updateReminderWithMissingCompletedReturns400() throws Exception {
        long plantId = createPlant("Aloe");

        String response = mockMvc.perform(post("/api/plants/" + plantId + "/reminders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"WATERING\",\"dueDate\":\"2026-08-20\",\"completed\":true}"))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        long reminderId = objectMapper.readTree(response).get("id").asLong();

        mockMvc.perform(put("/api/reminders/" + reminderId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"type\":\"WATERING\",\"dueDate\":\"2026-09-01\"}"))
                .andExpect(status().isBadRequest());

        mockMvc.perform(get("/api/plants/" + plantId + "/reminders"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].completed", is(true)));
    }
}
