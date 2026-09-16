package com.example.e7gzly.service;

import com.example.e7gzly.dto.AppointmentRequest;
import com.example.e7gzly.model.Appointment;
import com.example.e7gzly.model.AppointmentStatus;
import com.example.e7gzly.model.AppointmentUpdateRequest;
import com.example.e7gzly.model.Doctor;
import com.example.e7gzly.model.Patient;
import com.example.e7gzly.repository.AppointmentRepository;
import com.example.e7gzly.repository.DoctorRepository;
import com.example.e7gzly.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private PatientRepository patientRepository;

    public Appointment createAppointment(AppointmentRequest request) {
        Doctor doctor = doctorRepository.findById(request.getDoctorId())
                .orElseThrow(() -> new RuntimeException("Doctor not found"));

        Patient patient = patientRepository.findById(request.getPatientId())
                .orElseGet(() -> {
                    // Auto-create a dummy patient for testing purposes
                    Patient dummy = new Patient();
                    dummy.setName("Test Patient");
                    dummy.setEmail("test@example.com");
                    dummy.setPhone("1234567890");
                    return patientRepository.save(dummy);
                });

        Appointment appointment = new Appointment(
                request.getDate(),
                request.getTime(),
                AppointmentStatus.CONFIRMED,
                doctor,
                patient);

        return appointmentRepository.save(appointment);
    }

    public void cancelAppointment(Long appointmentId, Long patientId) {

        Appointment appointment = appointmentRepository
                .findByIdAndPatientId(appointmentId, patientId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        appointment.setStatus(AppointmentStatus.CANCELLED);

        appointmentRepository.save(appointment);
    }

    public List<Appointment> getPatientAppointments(Long patientId) {
        return appointmentRepository.findByPatientIdOrderByDateDesc(patientId);
    }

    public Appointment updateAppointment(
            Long appointmentId,
            Long patientId,
            AppointmentUpdateRequest request) {

        Appointment appointment = appointmentRepository
                .findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        if (!appointment.getPatient().getId().equals(patientId)) {
            throw new RuntimeException(
                    "You are not allowed to update this appointment");
        }

        appointment.setDate(request.getDate());
        appointment.setTime(request.getTime());

        return appointmentRepository.save(appointment);
    }
}
