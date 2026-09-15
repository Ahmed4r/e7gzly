package com.example.e7gzly.service;

import com.example.e7gzly.model.Clinic;
import com.example.e7gzly.repository.ClinicRepository;
import org.springframework.stereotype.Service;

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
}