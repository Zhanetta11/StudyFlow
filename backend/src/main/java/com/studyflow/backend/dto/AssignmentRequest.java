package com.studyflow.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

public record AssignmentRequest(
        @NotBlank(message = "Title is required")
        @Size(max = 255)
        String title,

        @NotBlank(message = "Course is required")
        @Size(max = 255)
        String course,

        boolean completed,

        LocalDate dueDate
) {
}