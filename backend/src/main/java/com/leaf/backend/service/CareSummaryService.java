package com.leaf.backend.service;

import java.util.List;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import com.leaf.backend.entity.CareLog;
import com.leaf.backend.entity.Plant;
import com.leaf.backend.exception.AiUnavailableException;

@Service
public class CareSummaryService {

    private final ChatClient chatClient;

    public CareSummaryService(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder.build();
    }

    public String generateSummary(Plant plant, List<CareLog> recentLogs) {
        try {
            return chatClient.prompt()
                    .user(buildPrompt(plant, recentLogs))
                    .call()
                    .content();
        } catch (RuntimeException ex) {
            throw new AiUnavailableException("Unable to generate a care summary right now", ex);
        }
    }

    private String buildPrompt(Plant plant, List<CareLog> recentLogs) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("You are a houseplant care assistant. Based on the plant details below, ")
                .append("write a short care summary of 2-3 sentences, including any relevant care tips.\n\n");

        prompt.append("Name: ").append(plant.getName()).append('\n');
        prompt.append("Species: ").append(plant.getSpecies() != null ? plant.getSpecies() : "unknown").append('\n');
        prompt.append("Watering frequency: every ").append(plant.getWateringFrequencyDays()).append(" days\n");
        prompt.append("Last watered: ")
                .append(plant.getLastWateredDate() != null ? plant.getLastWateredDate() : "not recorded")
                .append('\n');

        if (recentLogs.isEmpty()) {
            prompt.append("No care log entries yet for this plant.\n");
        } else {
            prompt.append("Recent care log notes, most recent first:\n");
            for (CareLog log : recentLogs) {
                prompt.append("- ").append(log.getNote()).append('\n');
            }
        }

        return prompt.toString();
    }
}
