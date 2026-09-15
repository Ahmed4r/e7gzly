package com.example.e7gzly.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.e7gzly.model.Clinic;

import java.util.List;

public interface ClinicRepository
        extends JpaRepository<Clinic, Long> {

    /**
     * Spring Data JPA derives this query automatically from the method name:
     * SELECT c FROM Clinic c
     * WHERE c.latitude BETWEEN minLat AND maxLat
     *   AND c.longitude BETWEEN minLng AND maxLng
     */
    List<Clinic> findByLatitudeBetweenAndLongitudeBetween(
            double minLat, double maxLat,
            double minLng, double maxLng
    );
}