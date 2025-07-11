// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_specifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarSpecifications _$CarSpecificationsFromJson(Map<String, dynamic> json) =>
    CarSpecifications(
      mileage: json['mileage'] as String,
      transmission: json['transmission'] as String,
      fuelType: json['fuel_type'] as String,
      maxSpeed: json['max_speed'] as String,
      seatingCapacity: (json['seating_capacity'] as num).toInt(),
      engineCapacity: json['engine_capacity'] as String?,
      carType: json['car_type'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CarSpecificationsToJson(CarSpecifications instance) =>
    <String, dynamic>{
      'mileage': instance.mileage,
      'transmission': instance.transmission,
      'fuel_type': instance.fuelType,
      'max_speed': instance.maxSpeed,
      'seating_capacity': instance.seatingCapacity,
      'engine_capacity': instance.engineCapacity,
      'car_type': instance.carType,
      'features': instance.features,
    };
