package com.example.e7gzly.controller;

import com.example.e7gzly.model.Clinic;
import com.example.e7gzly.service.ClinicService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/clinics")
public class ClinicController {

    private final ClinicService clinicService;

    public ClinicController(ClinicService clinicService) {
        this.clinicService = clinicService;
    }

    @GetMapping
    public List<Clinic> getAllClinics() {
        return clinicService.getAllClinics();
    }

    @GetMapping("/{id}")
    public Clinic getClinicById(@PathVariable Long id) {
        return clinicService.getClinicById(id);
    }

    @PostMapping
    public Clinic createClinic(@RequestBody Clinic clinic) {
        return clinicService.createClinic(clinic);
    }

    @PutMapping("/{id}")
    public Clinic updateClinic(
            @PathVariable Long id,
            @RequestBody Clinic clinic) {
        return clinicService.updateClinic(id, clinic);
    }

    @DeleteMapping("/{id}")
    public void deleteClinic(@PathVariable Long id) {
        clinicService.deleteClinic(id);
    }
}