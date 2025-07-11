import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final String id;
  final String name;
  final String address;
  @JsonKey(name: 'full_address')
  final String fullAddress;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'is_active')
  final bool isActive;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.isActive,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  // Helper methods
  String get displayAddress => '$address, $city, $state - $pincode';
  String get coordinates => '$latitude,$longitude';
} 