import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'car.dart';
import 'user.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'car_id')
  final String carId;
  final Car? car;
  final User? user;
  @JsonKey(name: 'pickup_date')
  final DateTime pickupDate;
  @JsonKey(name: 'dropoff_date')
  final DateTime dropoffDate;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'booking_status')
  final BookingStatus status;
  @JsonKey(name: 'payment_status')
  final PaymentStatus paymentStatus;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String? notes;

  Booking({
    required this.id,
    required this.userId,
    required this.carId,
    this.car,
    this.user,
    required this.pickupDate,
    required this.dropoffDate,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);

  // Helper methods
  String get totalAmountDisplay => '₹${totalAmount.toInt()}';
  String get durationDisplay {
    final duration = dropoffDate.difference(pickupDate).inDays;
    return duration == 1 ? '$duration day' : '$duration days';
  }
  
  Color get statusColor {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }
}

enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
} 