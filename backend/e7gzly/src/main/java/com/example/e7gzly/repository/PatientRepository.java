package com.example.e7gzly.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.e7gzly.model.Patient;

public interface PatientRepository
        extends JpaRepository<Patient, Long> {
}