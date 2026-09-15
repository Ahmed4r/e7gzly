package com.example.e7gzly.service;

import java.util.List;
import org.springframework.stereotype.Service;
import com.example.e7gzly.model.Doctor;
import com.example.e7gzly.repository.DoctorRepository;

@Service
public class DoctorService {
    private final DoctorRepository repo;

    public DoctorService(DoctorRepository repo) {
        this.repo = repo;
    }

    // get All doctors
    public List<Doctor> getAllDoctors() {
        return repo.findAll();

    }

    // get doctor by id
    public Doctor getDoctorById(Long id) {
        return repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));
    }

    // create
    public Doctor createDoctor(Doctor doctor) {
        return repo.save(doctor);
    }

    // delete
    public void deleteDoctor(Long id) {
        Doctor doctor = getDoctorById(id);
        repo.delete(doctor);
    }

    // update
    public Doctor updateDoctor(Long id, Doctor doctor) {

        System.out.println("UPDATE REQUEST ID = " + id);

        Doctor existingDoctor = getDoctorById(id);

        System.out.println("EXISTING DOCTOR ID = " + existingDoctor.getId());

        existingDoctor.setName(doctor.getName());
        existingDoctor.setImageUrl(doctor.getImageUrl());
        existingDoctor.setBio(doctor.getBio());
        existingDoctor.setExperienceYears(doctor.getExperienceYears());
        existingDoctor.setPhone(doctor.getPhone());
        existingDoctor.setSpecialty(doctor.getSpecialty());
        existingDoctor.setClinic(doctor.getClinic());
        existingDoctor.setWorkingDays(doctor.getWorkingDays());
        existingDoctor.setWorkingHours(doctor.getWorkingHours());

        Doctor result = repo.save(existingDoctor);

        System.out.println("SAVED DOCTOR ID = " + result.getId());

        return result;
    }

}
