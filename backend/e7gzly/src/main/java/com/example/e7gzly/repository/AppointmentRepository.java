package com.example.e7gzly.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.e7gzly.model.Appointment;

public interface AppointmentRepository
        extends JpaRepository<Appointment, Long> {
}