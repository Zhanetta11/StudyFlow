package com.studyflow.backend.controller;

import com.studyflow.backend.dto.AssignmentRequest;
import com.studyflow.backend.dto.AssignmentResponse;
import com.studyflow.backend.service.AssignmentService;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/assignments")
public class AssignmentController {

    private final AssignmentService service;

    public AssignmentController(AssignmentService service) {
        this.service = service;
    }

    @GetMapping
    public List<AssignmentResponse> getAllAssignments() {
        return service.getAllAssignments();
    }

    @GetMapping("/{id}")
    public AssignmentResponse getAssignmentById(
            @PathVariable Long id) {
        return service.getAssignmentById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public AssignmentResponse createAssignment(
            @Valid @RequestBody AssignmentRequest request) {

        return service.createAssignment(request);
    }

    @PutMapping("/{id}")
    public AssignmentResponse updateAssignment(
            @PathVariable Long id,
            @Valid @RequestBody AssignmentRequest request) {

        return service.updateAssignment(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteAssignment(@PathVariable Long id) {
        service.deleteAssignment(id);
    }
}