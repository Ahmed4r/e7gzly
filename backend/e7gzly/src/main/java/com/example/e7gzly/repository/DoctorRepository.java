package com.example.e7gzly.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.e7gzly.model.Doctor;

public interface DoctorRepository extends JpaRepository<Doctor, Long> {
}