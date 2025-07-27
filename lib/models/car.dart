import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'location.dart';
import 'car_specifications.dart';

part 'car.g.dart';

@JsonSerializable()
class Car {
  final String id;
  final String name;
  final String brand;
  @JsonKey(name: 'price_per_day')
  final double pricePerDay;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  final Location location;
  final CarSpecifications specifications;
  final bool availability;
  final double rating;
  @JsonKey(name: 'total_ratings')
  final int totalRatings;
  @JsonKey(name: 'managed_by')
  final String managedBy;
  @JsonKey(name: 'managed_by_address')
  final String managedByAddress;
  @JsonKey(name: 'distance_included')
  final int distanceIncluded;
  @JsonKey(name: 'average_price')
  final double averagePrice;
  final String description;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.pricePerDay,
    required this.imageUrl,
    this.thumbnailUrl,
    required this.location,
    required this.specifications,
    required this.availability,
    required this.rating,
    required this.totalRatings,
    required this.managedBy,
    required this.managedByAddress,
    required this.distanceIncluded,
    required this.averagePrice,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
  Map<String, dynamic> toJson() => _$CarToJson(this);

  // Helper methods for UI
  String get priceDisplay => '₹${pricePerDay.toInt()}';
  String get ratingDisplay => rating.toStringAsFixed(1);
  List<Widget> get ratingStars {
    return List.generate(5, (index) {
      return Icon(
        index < rating.round() ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 16,
      );
    });
  }

  // Provide fallback URL for failed images
  String get safeImageUrl {
    return imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/300x200?text=Car+Image';
  }
} 