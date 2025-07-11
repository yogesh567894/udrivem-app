import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String>? errors;
  final int? total;
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'per_page')
  final int? perPage;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.total,
    this.currentPage,
    this.perPage,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
} 