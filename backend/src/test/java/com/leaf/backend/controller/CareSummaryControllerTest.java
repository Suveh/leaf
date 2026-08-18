package com.leaf.backend.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import com.leaf.backend.entity.CareLog;
import com.leaf.backend.entity.Plant;
import com.leaf.backend.exception.AiUnavailableException;
import com.leaf.backend.service.CareSummaryService;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class CareSummaryControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private CareSummaryService careSummaryService;

    private long createPlant(String name) throws Exception {
        String response = mockMvc.perform(post("/api/plants")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"" + name + "\",\"wateringFrequencyDays\":7}"))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(response).get("id").asLong();
    }

    @Test
    void returnsGeneratedSummaryForExistingPlant() throws Exception {
        long plantId = createPlant("Monstera");
        when(careSummaryService.generateSummary(any(Plant.class), any()))
                .thenReturn("Water weekly and keep in bright, indirect light.");

        mockMvc.perform(get("/api/plants/" + plantId + "/care-summary"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.plantId").value((int) plantId))
                .andExpect(jsonPath("$.summary").value("Water weekly and keep in bright, indirect light."));
    }

    @Test
    void worksWithNoCareLogs() throws Exception {
        long plantId = createPlant("Pothos");
        when(careSummaryService.generateSummary(any(Plant.class), any()))
                .thenReturn("This plant has no history yet, but here's a general tip...");

        mockMvc.perform(get("/api/plants/" + plantId + "/care-summary"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.summary").exists());
    }

    @Test
    void unknownPlantReturns404() throws Exception {
        mockMvc.perform(get("/api/plants/999999/care-summary"))
                .andExpect(status().isNotFound());
    }

    @Test
    void aiFailureReturns503WithClearError() throws Exception {
        long plantId = createPlant("Fern");
        when(careSummaryService.generateSummary(any(Plant.class), any()))
                .thenThrow(new AiUnavailableException("Unable to generate a care summary right now", new RuntimeException("boom")));

        mockMvc.perform(get("/api/plants/" + plantId + "/care-summary"))
                .andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.message").value("Unable to generate a care summary right now"));
    }

    @Test
    void includesRecentCareLogNoteInGeneratedPrompt() throws Exception {
        long plantId = createPlant("Snake Plant");
        mockMvc.perform(post("/api/plants/" + plantId + "/logs")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"note\":\"Repotted into a larger pot\"}"))
                .andExpect(status().isCreated());

        when(careSummaryService.generateSummary(any(Plant.class), any()))
                .thenAnswer(invocation -> {
                    var logs = (java.util.List<CareLog>) invocation.getArgument(1);
                    return "Saw " + logs.size() + " recent log(s).";
                });

        mockMvc.perform(get("/api/plants/" + plantId + "/care-summary"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.summary").value("Saw 1 recent log(s)."));
    }
}
