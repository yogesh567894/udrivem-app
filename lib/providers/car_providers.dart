import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/car.dart';
import '../models/booking.dart';
import '../models/filters.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Car Filters Provider
final carFiltersProvider = StateProvider<CarFilters>((ref) => CarFilters());

// Cars Provider - fetches cars based on filters
final carsProvider = FutureProvider.family<List<Car>, CarFilters>((ref, filters) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getCars(filters: filters);
    return response.data ?? [];
  } catch (e) {
    // Fallback to mock data if API fails
    print('⚠️ API failed, using mock data: $e');
    await Future.delayed(const Duration(seconds: 1));
    return [
      Car(
        id: '1',
        name: 'XUV 700',
        brand: 'Mahindra',
        pricePerDay: 1000.0,
        imageUrl: 'https://images.mahindrasyouv.com/mahindrasyouv700/images/gallery/exterior/1.jpg',
        thumbnailUrl: null,
        location: Location(
          id: '1',
          name: 'Pondicherry Branch',
          address: '60, Kamaraj Salai',
          fullAddress: '60, Kamaraj Salai, Near Sayam, Kamaraj Salai, Puducherry, 605001',
          city: 'Puducherry',
          state: 'Puducherry',
          pincode: '605001',
          latitude: 11.9416,
          longitude: 79.8083,
          isActive: true,
        ),
        specifications: CarSpecifications(
          mileage: '17kmpl',
          transmission: 'Manual',
          fuelType: 'Petrol',
          maxSpeed: '180 km/h',
          seatingCapacity: 7,
          engineCapacity: '2.0L',
          carType: 'SUV',
          features: ['AC', 'Power Steering', 'Bluetooth', 'GPS'],
        ),
        availability: true,
        rating: 4.5,
        totalRatings: 128,
        managedBy: 'Mahindra Auto',
        managedByAddress: 'Pondicherry Branch',
        distanceIncluded: 100,
        averagePrice: 950.0,
        description: 'Premium SUV with advanced features and comfortable seating for 7 passengers.',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Car(
        id: '2',
        name: 'Swift',
        brand: 'Maruti Suzuki',
        pricePerDay: 800.0,
        imageUrl: 'https://via.placeholder.com/320x144.png?text=Swift',
        thumbnailUrl: null,
        location: Location(
          id: '1',
          name: 'Pondicherry Branch',
          address: '60, Kamaraj Salai',
          fullAddress: '60, Kamaraj Salai, Near Sayam, Kamaraj Salai, Puducherry, 605001',
          city: 'Puducherry',
          state: 'Puducherry',
          pincode: '605001',
          latitude: 11.9416,
          longitude: 79.8083,
          isActive: true,
        ),
        specifications: CarSpecifications(
          mileage: '22kmpl',
          transmission: 'Manual',
          fuelType: 'Petrol',
          maxSpeed: '160 km/h',
          seatingCapacity: 5,
          engineCapacity: '1.2L',
          carType: 'Hatchback',
          features: ['AC', 'Power Steering', 'Music System'],
        ),
        availability: true,
        rating: 4.2,
        totalRatings: 95,
        managedBy: 'Maruti Suzuki',
        managedByAddress: 'Pondicherry Branch',
        distanceIncluded: 100,
        averagePrice: 750.0,
        description: 'Compact and fuel-efficient hatchback perfect for city driving.',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
});

// Bookings Provider
final bookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getBookings();
    return response.data ?? [];
  } catch (e) {
    // Fallback to mock data if API fails
    print('⚠️ API failed, using mock data: $e');
    await Future.delayed(const Duration(seconds: 1));
    return [
      Booking(
        id: '1',
        userId: 'user1',
        carId: '1',
        car: null, // Will be populated by API
        user: null, // Will be populated by API
        pickupDate: DateTime.now().add(const Duration(days: 2)),
        dropoffDate: DateTime.now().add(const Duration(days: 5)),
        totalAmount: 3000.0,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.pending,
        paymentMethod: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: null,
      ),
      Booking(
        id: '2',
        userId: 'user1',
        carId: '2',
        car: null,
        user: null,
        pickupDate: DateTime.now().subtract(const Duration(days: 10)),
        dropoffDate: DateTime.now().subtract(const Duration(days: 7)),
        totalAmount: 2400.0,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.completed,
        paymentMethod: 'Credit Card',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        notes: null,
      ),
    ];
  }
});

// Selected Car Provider
final selectedCarProvider = StateProvider<Car?>((ref) => null);

// Booking Filters Provider
final bookingFiltersProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// User Profile Provider
final userProfileProvider = FutureProvider<User?>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getUserProfile();
    return response.data;
  } catch (e) {
    print('⚠️ Failed to fetch user profile: $e');
    return null;
  }
});

// Locations Provider
final locationsProvider = FutureProvider<List<Location>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.getLocations();
    return response.data ?? [];
  } catch (e) {
    print('⚠️ Failed to fetch locations: $e');
    return [];
  }
});

// Authentication Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref.read(apiServiceProvider)));

// Auth State
class AuthState {
  final bool isAuthenticated;
  final String? token;
  final User? user;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    User? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(AuthState());

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(error: null);
      final response = await _apiService.login(email: email, password: password);
      if (response.success && response.data != null) {
        final token = response.data!['token'] as String;
        state = state.copyWith(
          isAuthenticated: true,
          token: token,
        );
      } else {
        state = state.copyWith(error: response.message);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> register(String name, String email, String password, String phone) async {
    try {
      state = state.copyWith(error: null);
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      if (response.success && response.data != null) {
        final token = response.data!['token'] as String;
        state = state.copyWith(
          isAuthenticated: true,
          token: token,
        );
      } else {
        state = state.copyWith(error: response.message);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void logout() {
    state = AuthState();
  }
} 