package com.studyflow.backend.dto;

import java.time.LocalDate;

public record AssignmentResponse(
        Long id,
        String title,
        String course,
        boolean completed,
        LocalDate dueDate
) {
}