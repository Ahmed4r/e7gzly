package com.example.e7gzly.controller;

import com.example.e7gzly.dto.AppointmentRequest;
import com.example.e7gzly.model.Appointment;
import com.example.e7gzly.model.AppointmentUpdateRequest;
import com.example.e7gzly.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/appointments")
@CrossOrigin(origins = "*") // Adjust origin for production
public class AppointmentController {

    @Autowired
    private AppointmentService appointmentService;

    @PostMapping
    public ResponseEntity<Appointment> createAppointment(@RequestBody AppointmentRequest request) {
        Appointment appointment = appointmentService.createAppointment(request);
        return new ResponseEntity<>(appointment, HttpStatus.CREATED);
    }

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<Appointment>> getPatientAppointments(@PathVariable Long patientId) {
        List<Appointment> appointments = appointmentService.getPatientAppointments(patientId);
        return ResponseEntity.ok(appointments);
    }

    @PatchMapping("/{appointmentId}/patient/{patientId}/cancel")
    public ResponseEntity<Void> cancelAppointment(
            @PathVariable Long appointmentId,
            @PathVariable Long patientId) {

        appointmentService.cancelAppointment(appointmentId, patientId);

        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{appointmentId}/patient/{patientId}")
    public ResponseEntity<Appointment> updateAppointment(
            @PathVariable Long appointmentId,
            @PathVariable Long patientId,
            @RequestBody AppointmentUpdateRequest request) {

        Appointment updatedAppointment = appointmentService.updateAppointment(
                appointmentId,
                patientId,
                request);

        return ResponseEntity.ok(updatedAppointment);
    }
}
