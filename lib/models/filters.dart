import 'package:json_annotation/json_annotation.dart';

part 'filters.g.dart';

@JsonSerializable()
class CarFilters {
  final String? location;
  final String? city;
  @JsonKey(name: 'price_min')
  final double? priceMin;
  @JsonKey(name: 'price_max')
  final double? priceMax;
  @JsonKey(name: 'car_type')
  final String? carType;
  @JsonKey(name: 'fuel_type')
  final String? fuelType;
  final String? transmission;
  @JsonKey(name: 'seating_capacity')
  final int? seatingCapacity;
  @JsonKey(name: 'available_from')
  final DateTime? availableFrom;
  @JsonKey(name: 'available_to')
  final DateTime? availableTo;
  @JsonKey(name: 'sort_by')
  final String? sortBy;
  @JsonKey(name: 'sort_order')
  final String? sortOrder;

  CarFilters({
    this.location,
    this.city,
    this.priceMin,
    this.priceMax,
    this.carType,
    this.fuelType,
    this.transmission,
    this.seatingCapacity,
    this.availableFrom,
    this.availableTo,
    this.sortBy,
    this.sortOrder,
  });

  factory CarFilters.fromJson(Map<String, dynamic> json) => 
      _$CarFiltersFromJson(json);
  Map<String, dynamic> toJson() => _$CarFiltersToJson(this);

  // Helper method to convert to query parameters
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (location != null) params['location'] = location;
    if (city != null) params['city'] = city;
    if (priceMin != null) params['price_min'] = priceMin;
    if (priceMax != null) params['price_max'] = priceMax;
    if (carType != null) params['car_type'] = carType;
    if (fuelType != null) params['fuel_type'] = fuelType;
    if (transmission != null) params['transmission'] = transmission;
    if (seatingCapacity != null) params['seating_capacity'] = seatingCapacity;
    if (availableFrom != null) params['available_from'] = availableFrom!.toIso8601String();
    if (availableTo != null) params['available_to'] = availableTo!.toIso8601String();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    return params;
  }
} 