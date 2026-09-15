import 'package:e7gzly/features/home/data/clinic_model.dart';
import 'package:e7gzly/features/home/data/specialty_model.dart';

class DoctorModel {
  final int id;
  final String name;
  final String? imageUrl;
  final String? bio;
  final int? experienceYears;
  final String? phone;

  final int? patientsCount;
  final double? rating;
  final int? reviewsCount;
  final String? workingDays;
  final String? workingHours;

  final SpecialtyModel specialty;
  final ClinicModel clinic;

  DoctorModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.bio,
    this.experienceYears,
    this.phone,
    this.patientsCount,
    this.rating,
    this.reviewsCount,
    this.workingDays,
    this.workingHours,
    required this.specialty,
    required this.clinic,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      bio: json['bio'],
      experienceYears: json['experienceYears'],
      phone: json['phone'],

      patientsCount: json['patientsCount'],
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviewsCount'],
      workingDays: json['workingDays'],
      workingHours: json['workingHours'],

      specialty: SpecialtyModel.fromJson(json['specialty']),
      clinic: ClinicModel.fromJson(json['clinic']),
    );
  }
}

