// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarFilters _$CarFiltersFromJson(Map<String, dynamic> json) => CarFilters(
  location: json['location'] as String?,
  city: json['city'] as String?,
  priceMin: (json['price_min'] as num?)?.toDouble(),
  priceMax: (json['price_max'] as num?)?.toDouble(),
  carType: json['car_type'] as String?,
  fuelType: json['fuel_type'] as String?,
  transmission: json['transmission'] as String?,
  seatingCapacity: (json['seating_capacity'] as num?)?.toInt(),
  availableFrom:
      json['available_from'] == null
          ? null
          : DateTime.parse(json['available_from'] as String),
  availableTo:
      json['available_to'] == null
          ? null
          : DateTime.parse(json['available_to'] as String),
  sortBy: json['sort_by'] as String?,
  sortOrder: json['sort_order'] as String?,
);

Map<String, dynamic> _$CarFiltersToJson(CarFilters instance) =>
    <String, dynamic>{
      'location': instance.location,
      'city': instance.city,
      'price_min': instance.priceMin,
      'price_max': instance.priceMax,
      'car_type': instance.carType,
      'fuel_type': instance.fuelType,
      'transmission': instance.transmission,
      'seating_capacity': instance.seatingCapacity,
      'available_from': instance.availableFrom?.toIso8601String(),
      'available_to': instance.availableTo?.toIso8601String(),
      'sort_by': instance.sortBy,
      'sort_order': instance.sortOrder,
    };
