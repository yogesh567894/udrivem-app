// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  carId: json['car_id'] as String,
  car:
      json['car'] == null
          ? null
          : Car.fromJson(json['car'] as Map<String, dynamic>),
  user:
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
  pickupDate: DateTime.parse(json['pickup_date'] as String),
  dropoffDate: DateTime.parse(json['dropoff_date'] as String),
  totalAmount: (json['total_amount'] as num).toDouble(),
  status: $enumDecode(_$BookingStatusEnumMap, json['booking_status']),
  paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['payment_status']),
  paymentMethod: json['payment_method'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'car_id': instance.carId,
  'car': instance.car,
  'user': instance.user,
  'pickup_date': instance.pickupDate.toIso8601String(),
  'dropoff_date': instance.dropoffDate.toIso8601String(),
  'total_amount': instance.totalAmount,
  'booking_status': _$BookingStatusEnumMap[instance.status]!,
  'payment_status': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'payment_method': instance.paymentMethod,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'notes': instance.notes,
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
