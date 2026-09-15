package com.example.e7gzly.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.e7gzly.model.Specialty;

public interface SpecialtyRepository
        extends JpaRepository<Specialty, Long> {
}