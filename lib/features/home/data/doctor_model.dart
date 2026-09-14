class DoctorModel {
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;

  DoctorModel({
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'] as String? ?? 'Unknown',
      specialty: json['specialty'] as String? ?? 'Not specified',
      location: json['location'] as String? ?? 'Unknown Location',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as int? ?? 0,
    );
  }
}