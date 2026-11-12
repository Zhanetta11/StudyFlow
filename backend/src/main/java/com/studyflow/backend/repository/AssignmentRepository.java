package com.studyflow.backend.repository;

import com.studyflow.backend.entity.Assignment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AssignmentRepository
        extends JpaRepository<Assignment, Long> {
}