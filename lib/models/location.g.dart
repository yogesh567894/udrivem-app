// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  fullAddress: json['full_address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  pincode: json['pincode'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'full_address': instance.fullAddress,
  'city': instance.city,
  'state': instance.state,
  'pincode': instance.pincode,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'is_active': instance.isActive,
};
