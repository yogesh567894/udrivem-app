import 'package:dio/dio.dart';
import '../config.dart';
import '../models/car.dart';
import '../models/booking.dart';
import '../models/filters.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../models/location.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Config.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<bool> joinCar(String carId) async {
    try {
      await _dio.post('/api/car_join', data: {'car_id': carId});
      print('✅ Car joined successfully: $carId');
      return true;
    } catch (e) {
      print('❌ API Join Error: $e');
      return false;
    }
  }

  Future<bool> updateLocation(String carId, double lat, double lng) async {
    try {
      await _dio.post('/api/car_update_location', data: {
        'car_id': carId,
        'lat': lat,
        'lng': lng,
      });
      print('📍 Location updated: $carId at ($lat, $lng)');
      return true;
    } catch (e) {
      print('❌ Location Update Error: $e');
      return false;
    }
  }

  // Car Services
  Future<ApiResponse<List<Car>>> getCars({CarFilters? filters}) async {
    try {
      final queryParams = filters?.toQueryParams() ?? {};
      final response = await _dio.get('/api/cars', queryParameters: queryParams);
      
      final apiResponse = ApiResponse<List<Car>>.fromJson(
        response.data,
        (json) => (json as List).map((carJson) => Car.fromJson(carJson as Map<String, dynamic>)).toList(),
      );
      
      print('✅ Fetched ${apiResponse.data?.length ?? 0} cars');
      return apiResponse;
    } catch (e) {
      print('❌ Get Cars Error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<Car>> getCarById(String carId) async {
    try {
      final response = await _dio.get('/api/cars/$carId');
      
      final apiResponse = ApiResponse<Car>.fromJson(
        response.data,
        (json) => Car.fromJson(json as Map<String, dynamic>),
      );
      
      print('✅ Fetched car: ${apiResponse.data?.name}');
      return apiResponse;
    } catch (e) {
      print('❌ Get Car Error: $e');
      rethrow;
    }
  }

  // Booking Services
  Future<ApiResponse<List<Booking>>> getBookings() async {
    try {
      final response = await _dio.get('/api/bookings');
      
      final apiResponse = ApiResponse<List<Booking>>.fromJson(
        response.data,
        (json) => (json as List).map((bookingJson) => Booking.fromJson(bookingJson as Map<String, dynamic>)).toList(),
      );
      
      print('✅ Fetched ${apiResponse.data?.length ?? 0} bookings');
      return apiResponse;
    } catch (e) {
      print('❌ Get Bookings Error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<Booking>> createBooking({
    required String carId,
    required DateTime pickupDate,
    required DateTime dropoffDate,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/api/bookings', data: {
        'car_id': carId,
        'pickup_date': pickupDate.toIso8601String(),
        'dropoff_date': dropoffDate.toIso8601String(),
        'notes': notes,
      });
      
      final apiResponse = ApiResponse<Booking>.fromJson(
        response.data,
        (json) => Booking.fromJson(json as Map<String, dynamic>),
      );
      
      print('✅ Booking created: ${apiResponse.data?.id}');
      return apiResponse;
    } catch (e) {
      print('❌ Create Booking Error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<Booking>> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      final response = await _dio.patch('/api/bookings/$bookingId/status', data: {
        'status': status.name,
      });
      
      final apiResponse = ApiResponse<Booking>.fromJson(
        response.data,
        (json) => Booking.fromJson(json as Map<String, dynamic>),
      );
      
      print('✅ Booking status updated: ${apiResponse.data?.id} to ${status.name}');
      return apiResponse;
    } catch (e) {
      print('❌ Update Booking Status Error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<Booking>> cancelBooking(String bookingId) async {
    try {
      final response = await _dio.delete('/api/bookings/$bookingId');
      
      final apiResponse = ApiResponse<Booking>.fromJson(
        response.data,
        (json) => Booking.fromJson(json as Map<String, dynamic>),
      );
      
      print('✅ Booking cancelled: ${apiResponse.data?.id}');
      return apiResponse;
    } catch (e) {
      print('❌ Cancel Booking Error: $e');
      rethrow;
    }
  }

  // User Services
  Future<ApiResponse<User>> getUserProfile() async {
    try {
      final response = await _dio.get('/api/user/profile');
      
      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
      
      print('✅ Fetched user profile: ${apiResponse.data?.name}');
      return apiResponse;
    } catch (e) {
      print('❌ Get User Profile Error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<User>> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.put('/api/user/profile', data: userData);
      
      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
      
      print('✅ User profile updated: ${apiResponse.data?.name}');
      return apiResponse;
    } catch (e) {
      print('❌ Update User Profile Error: $e');
      rethrow;
    }
  }

  // Authentication Services
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      
      print('✅ User logged in successfully');
      return apiResponse;
    } catch (e) {
      print('❌ Login Error: $e');
      rethrow;
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _dio.post('/api/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      
      print('✅ User registered successfully');
      return apiResponse;
    } catch (e) {
      print('❌ Register Error: $e');
      rethrow;
    }
  }

  // Payment Services
  Future<ApiResponse<Map<String, dynamic>>> processPayment({
    required String bookingId,
    required String paymentMethod,
    required double amount,
  }) async {
    try {
      final response = await _dio.post('/api/payments/process', data: {
        'booking_id': bookingId,
        'payment_method': paymentMethod,
        'amount': amount,
      });
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      
      print('✅ Payment processed successfully');
      return apiResponse;
    } catch (e) {
      print('❌ Payment Error: $e');
      rethrow;
    }
  }

  // Location Services
  Future<ApiResponse<List<Location>>> getLocations() async {
    try {
      final response = await _dio.get('/api/locations');
      
      final apiResponse = ApiResponse<List<Location>>.fromJson(
        response.data,
        (json) => (json as List).map((locationJson) => Location.fromJson(locationJson as Map<String, dynamic>)).toList(),
      );
      
      print('✅ Fetched ${apiResponse.data?.length ?? 0} locations');
      return apiResponse;
    } catch (e) {
      print('❌ Get Locations Error: $e');
      rethrow;
    }
  }
} 