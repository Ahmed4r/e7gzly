package com.example.e7gzly.service;

import com.example.e7gzly.model.Clinic;
import com.example.e7gzly.repository.ClinicRepository;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;

@Service
public class ClinicService {

    private final ClinicRepository clinicRepository;

    public ClinicService(ClinicRepository clinicRepository) {
        this.clinicRepository = clinicRepository;
    }

    public List<Clinic> getAllClinics() {
        return clinicRepository.findAll();
    }

    public Clinic getClinicById(Long id) {
        return clinicRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Clinic not found"));
    }

    public Clinic createClinic(Clinic clinic) {
        return clinicRepository.save(clinic);
    }

    public Clinic updateClinic(Long id, Clinic clinic) {
        Clinic existingClinic = getClinicById(id);

        existingClinic.setName(clinic.getName());
        existingClinic.setAddress(clinic.getAddress());
        existingClinic.setPhone(clinic.getPhone());
        existingClinic.setImageUrl(clinic.getImageUrl());
        existingClinic.setLatitude(clinic.getLatitude());
        existingClinic.setLongitude(clinic.getLongitude());

        existingClinic.setType(clinic.getType());
        existingClinic.setRating(clinic.getRating());
        existingClinic.setReviewsCount(clinic.getReviewsCount());
        existingClinic.setDepartmentsCount(clinic.getDepartmentsCount());
        existingClinic.setDescription(clinic.getDescription());

        return clinicRepository.save(existingClinic);
    }

    public void deleteClinic(Long id) {
        Clinic clinic = getClinicById(id);
        clinicRepository.delete(clinic);
    }

    /**
     * Returns clinics within {@code radiusKm} kilometres of the supplied
     * coordinates, sorted by ascending Haversine distance.
     *
     * @param lat      user latitude  (decimal degrees)
     * @param lng      user longitude (decimal degrees)
     * @param radiusKm search radius  in kilometres
     */
    public List<Clinic> getNearbyClinics(double lat, double lng, double radiusKm) {
        // 1 degree of latitude  ≈ 111 km  →  delta lat for the bounding box
        double latDelta = radiusKm / 111.0;
        // 1 degree of longitude ≈ 111 km × cos(lat)
        double lngDelta = radiusKm / (111.0 * Math.cos(Math.toRadians(lat)));

        List<Clinic> candidates = clinicRepository.findByLatitudeBetweenAndLongitudeBetween(
                lat - latDelta, lat + latDelta,
                lng - lngDelta, lng + lngDelta
        );

        // Precise Haversine filter + sort
        return candidates.stream()
                .filter(c -> haversineKm(lat, lng, c.getLatitude(), c.getLongitude()) <= radiusKm)
                .sorted(Comparator.comparingDouble(
                        c -> haversineKm(lat, lng, c.getLatitude(), c.getLongitude())))
                .toList();
    }

    /** Haversine formula — returns distance between two WGS-84 points in km. */
    private double haversineKm(double lat1, double lng1, double lat2, double lng2) {
        final double R = 6371.0; // Earth radius in km
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLng / 2) * Math.sin(dLng / 2);
        return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    }
}