package com.example.e7gzly.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.e7gzly.model.Clinic;

public interface ClinicRepository
        extends JpaRepository<Clinic, Long> {
}