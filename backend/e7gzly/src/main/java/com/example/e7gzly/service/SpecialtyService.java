package com.example.e7gzly.service;

import com.example.e7gzly.model.Specialty;
import com.example.e7gzly.repository.SpecialtyRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SpecialtyService {

    private final SpecialtyRepository specialtyRepository;

    public SpecialtyService(SpecialtyRepository specialtyRepository) {
        this.specialtyRepository = specialtyRepository;
    }

    public List<Specialty> getAllSpecialties() {
        return specialtyRepository.findAll();
    }

    public Specialty getSpecialtyById(Long id) {
        return specialtyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Specialty not found"));
    }

    public Specialty createSpecialty(Specialty specialty) {
        return specialtyRepository.save(specialty);
    }

    public Specialty updateSpecialty(Long id, Specialty specialty) {
        Specialty existingSpecialty = getSpecialtyById(id);

        existingSpecialty.setName(specialty.getName());
        existingSpecialty.setDescription(specialty.getDescription());
        existingSpecialty.setIconUrl(specialty.getIconUrl());

        return specialtyRepository.save(existingSpecialty);
    }

    public void deleteSpecialty(Long id) {
        Specialty specialty = getSpecialtyById(id);
        specialtyRepository.delete(specialty);
    }
}