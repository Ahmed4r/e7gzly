package com.example.e7gzly.controller;

import com.example.e7gzly.model.Specialty;
import com.example.e7gzly.service.SpecialtyService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/specialties")
public class SpecialtyController {

    private final SpecialtyService specialtyService;

    public SpecialtyController(SpecialtyService specialtyService) {
        this.specialtyService = specialtyService;
    }

    @GetMapping
    public List<Specialty> getAllSpecialties() {
        return specialtyService.getAllSpecialties();
    }

    @GetMapping("/{id}")
    public Specialty getSpecialtyById(@PathVariable Long id) {
        return specialtyService.getSpecialtyById(id);
    }

    @PostMapping
    public Specialty createSpecialty(@RequestBody Specialty specialty) {
        return specialtyService.createSpecialty(specialty);
    }

    @PutMapping("/{id}")
    public Specialty updateSpecialty(
            @PathVariable Long id,
            @RequestBody Specialty specialty
    ) {
        return specialtyService.updateSpecialty(id, specialty);
    }

    @DeleteMapping("/{id}")
    public void deleteSpecialty(@PathVariable Long id) {
        specialtyService.deleteSpecialty(id);
    }
}