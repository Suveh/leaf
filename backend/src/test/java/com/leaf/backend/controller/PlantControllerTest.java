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
class PlantControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void createPlantReturns201WithLocationAndBody() throws Exception {
        mockMvc.perform(post("/api/plants")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"name":"Monstera","species":"Monstera deliciosa","wateringFrequencyDays":7}
                                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.name", is("Monstera")))
                .andExpect(jsonPath("$.wateringFrequencyDays", is(7)));
    }

    @Test
    void createPlantWithBlankNameReturns400() throws Exception {
        mockMvc.perform(post("/api/plants")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"name":"","wateringFrequencyDays":7}
                                """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors.name").exists());
    }

    @Test
    void createPlantWithNonPositiveWateringFrequencyReturns400() throws Exception {
        mockMvc.perform(post("/api/plants")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"name":"Pothos","wateringFrequencyDays":0}
                                """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors.wateringFrequencyDays").exists());
    }

    @Test
    void getUnknownPlantReturns404() throws Exception {
        mockMvc.perform(get("/api/plants/999999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void updateAndDeletePlantRoundTrip() throws Exception {
        String createResponse = mockMvc.perform(post("/api/plants")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"name":"Fern","wateringFrequencyDays":3}
                                """))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        long id = objectMapper.readTree(createResponse).get("id").asLong();

        mockMvc.perform(put("/api/plants/" + id)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"name":"Fern Updated","wateringFrequencyDays":5}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Fern Updated")))
                .andExpect(jsonPath("$.wateringFrequencyDays", is(5)));

        mockMvc.perform(delete("/api/plants/" + id))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/plants/" + id))
                .andExpect(status().isNotFound());
    }
}
