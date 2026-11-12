package com.studyflow.backend.dto;

public record AssignmentResponse(
        Long id,
        String title,
        String course,
        boolean completed
) {
}