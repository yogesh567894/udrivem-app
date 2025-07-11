class CarModel {
  final String id;
  final double lat;
  final double lng;
  final DateTime lastUpdated;
  
  CarModel({
    required this.id,
    required this.lat,
    required this.lng,
    required this.lastUpdated,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    id: json['car_id'] ?? '',
    lat: (json['lat'] ?? 0.0).toDouble(),
    lng: (json['lng'] ?? 0.0).toDouble(),
    lastUpdated: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'car_id': id,
    'lat': lat,
    'lng': lng,
  };
} 