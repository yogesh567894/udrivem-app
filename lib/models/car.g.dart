// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
  id: json['id'] as String,
  name: json['name'] as String,
  brand: json['brand'] as String,
  pricePerDay: (json['price_per_day'] as num).toDouble(),
  imageUrl: json['image_url'] as String,
  thumbnailUrl: json['thumbnail_url'] as String?,
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  specifications: CarSpecifications.fromJson(
    json['specifications'] as Map<String, dynamic>,
  ),
  availability: json['availability'] as bool,
  rating: (json['rating'] as num).toDouble(),
  totalRatings: (json['total_ratings'] as num).toInt(),
  managedBy: json['managed_by'] as String,
  managedByAddress: json['managed_by_address'] as String,
  distanceIncluded: (json['distance_included'] as num).toInt(),
  averagePrice: (json['average_price'] as num).toDouble(),
  description: json['description'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'brand': instance.brand,
  'price_per_day': instance.pricePerDay,
  'image_url': instance.imageUrl,
  'thumbnail_url': instance.thumbnailUrl,
  'location': instance.location,
  'specifications': instance.specifications,
  'availability': instance.availability,
  'rating': instance.rating,
  'total_ratings': instance.totalRatings,
  'managed_by': instance.managedBy,
  'managed_by_address': instance.managedByAddress,
  'distance_included': instance.distanceIncluded,
  'average_price': instance.averagePrice,
  'description': instance.description,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
