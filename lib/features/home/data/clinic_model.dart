class ClinicModel {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  final String? type;
  final double? rating;
  final int? reviewsCount;
  final int? departmentsCount;
  final String? description;

  ClinicModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.type,
    this.rating,
    this.reviewsCount,
    this.departmentsCount,
    this.description,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),

      type: json['type'],
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviewsCount'],
      departmentsCount: json['departmentsCount'],
      description: json['description'],
    );
  }
}