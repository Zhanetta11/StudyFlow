package com.studyflow.backend.service;

import com.studyflow.backend.dto.AssignmentRequest;
import com.studyflow.backend.dto.AssignmentResponse;
import com.studyflow.backend.entity.Assignment;
import com.studyflow.backend.repository.AssignmentRepository;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class AssignmentService {

    private final AssignmentRepository repository;

    public AssignmentService(AssignmentRepository repository) {
        this.repository = repository;
    }

    public List<AssignmentResponse> getAllAssignments() {
        return repository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    public AssignmentResponse getAssignmentById(Long id) {
        return toResponse(findAssignment(id));
    }

    public AssignmentResponse createAssignment(
            AssignmentRequest request) {

        Assignment assignment = new Assignment(
                request.title(),
                request.course()
        );

        assignment.setCompleted(request.completed());

        // Save the assignment deadline
        assignment.setDueDate(request.dueDate());

        return toResponse(repository.save(assignment));
    }

    public AssignmentResponse updateAssignment(
            Long id,
            AssignmentRequest request) {

        Assignment assignment = findAssignment(id);

        assignment.setTitle(request.title());
        assignment.setCourse(request.course());
        assignment.setCompleted(request.completed());

        // Update the assignment deadline
        assignment.setDueDate(request.dueDate());

        return toResponse(repository.save(assignment));
    }

    public void deleteAssignment(Long id) {
        Assignment assignment = findAssignment(id);
        repository.delete(assignment);
    }

    private Assignment findAssignment(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Assignment not found"
                ));
    }

    private AssignmentResponse toResponse(Assignment assignment) {
        return new AssignmentResponse(
                assignment.getId(),
                assignment.getTitle(),
                assignment.getCourse(),
                assignment.isCompleted(),
                assignment.getDueDate()
        );
    }
}