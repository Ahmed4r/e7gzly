import 'package:e7gzly/features/home/data/doctor_model.dart';

class AppointmentModel {
  final int id;
  final String date;
  final String time;
  final String status;
  final DoctorModel doctor;

  AppointmentModel({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.doctor,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      doctor: DoctorModel.fromJson(json['doctor']),
    );
  }
}
