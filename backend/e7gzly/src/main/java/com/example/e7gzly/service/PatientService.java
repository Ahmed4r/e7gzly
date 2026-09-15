package com.example.e7gzly.service;

import com.example.e7gzly.model.Patient;
import com.example.e7gzly.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    public Patient getPatientById(Long id) {
        return patientRepository.findById(id)
                .orElseGet(() -> {
                    // Auto-create dummy patient if doesn't exist
                    Patient dummy = new Patient();
                    dummy.setName("Daniel Martinez");
                    dummy.setEmail("daniel@example.com");
                    dummy.setPhone("+123 856479683");
                    return patientRepository.save(dummy);
                });
    }
}
