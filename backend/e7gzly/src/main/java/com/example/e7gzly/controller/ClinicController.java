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

    /**
     * GET /api/clinics/nearby?lat={lat}&lng={lng}&radius={km}
     *
     * Returns clinics within {@code radius} kilometres of the supplied
     * coordinates, sorted by ascending distance.
     *
     * @param lat    user latitude  (decimal degrees)
     * @param lng    user longitude (decimal degrees)
     * @param radius search radius  in kilometres (default 5 km)
     */
    @GetMapping("/nearby")
    public List<Clinic> getNearbyClinics(
            @RequestParam double lat,
            @RequestParam double lng,
            @RequestParam(defaultValue = "5") double radius) {
        return clinicService.getNearbyClinics(lat, lng, radius);
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