package com.studyflow.backend.entity;

import java.time.LocalDate;
import jakarta.persistence.*;

@Entity
@Table(name = "assignments")
public class Assignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String course;

    @Column(nullable = false)
    private boolean completed = false;

    // Optional assignment deadline
    @Column(name = "due_date")
    private LocalDate dueDate;

    public Assignment() {
    }

    public Assignment(String title, String course) {
        this.title = title;
        this.course = course;
    }

    public Assignment(
            String title,
            String course,
            LocalDate dueDate
    ) {
        this.title = title;
        this.course = course;
        this.dueDate = dueDate;
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
}