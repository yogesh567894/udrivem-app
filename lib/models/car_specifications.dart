import 'package:json_annotation/json_annotation.dart';

part 'car_specifications.g.dart';

@JsonSerializable()
class CarSpecifications {
  final String mileage;
  final String transmission;
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @JsonKey(name: 'max_speed')
  final String maxSpeed;
  @JsonKey(name: 'seating_capacity')
  final int seatingCapacity;
  @JsonKey(name: 'engine_capacity')
  final String? engineCapacity;
  @JsonKey(name: 'car_type')
  final String carType;
  final List<String> features;

  CarSpecifications({
    required this.mileage,
    required this.transmission,
    required this.fuelType,
    required this.maxSpeed,
    required this.seatingCapacity,
    this.engineCapacity,
    required this.carType,
    required this.features,
  });

  factory CarSpecifications.fromJson(Map<String, dynamic> json) => 
      _$CarSpecificationsFromJson(json);
  Map<String, dynamic> toJson() => _$CarSpecificationsToJson(this);

  // Helper methods for UI display
  String get seatingDisplay => '$seatingCapacity Person';
  String get mileageDisplay => '$mileage+';
} 