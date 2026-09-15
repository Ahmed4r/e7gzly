class PatientModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? imageUrl;

  PatientModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.imageUrl,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      imageUrl: json['imageUrl'],
    );
  }
}
