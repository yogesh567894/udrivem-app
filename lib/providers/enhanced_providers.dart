import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/car.dart';
import '../models/booking.dart';
import '../models/filters.dart';
import '../models/user.dart';
import '../models/location.dart';
import '../models/car_specifications.dart';
import '../services/api_service.dart';

// Auth State Class - Define this first
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

// API Service Provider
final apiServiceProvider = Provider((ref) => ApiService());

// Car Filters Provider
final carFiltersProvider = StateProvider<CarFilters>((ref) => CarFilters());

// Cars Provider - Fixed syntax
final carsProvider = FutureProvider<List<Car>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  
  try {
    final response = await apiService.getCars();
    return response.data ?? [];
  } catch (e) {
    print('⚠️ API failed, using mock data: $e');
    return _getMockCars();
  }
});

// Filter Notifier Class
class CarFiltersNotifier extends StateNotifier<CarFilters> {
  CarFiltersNotifier() : super(CarFilters());
  
  void updateLocation(String? location) {
    state = state.copyWith(location: location);
  }
  
  void updateCity(String? city) {
    state = state.copyWith(city: city);
  }
  
  void updatePriceRange(double? min, double? max) {
    state = state.copyWith(priceMin: min, priceMax: max);
  }
  
  void updateCarType(String? carType) {
    state = state.copyWith(carType: carType);
  }
  
  void updateFuelType(String? fuelType) {
    state = state.copyWith(fuelType: fuelType);
  }
  
  void updateTransmission(String? transmission) {
    state = state.copyWith(transmission: transmission);
  }
  
  void updateSeatingCapacity(int? capacity) {
    state = state.copyWith(seatingCapacity: capacity);
  }
  
  void updateDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(availableFrom: from, availableTo: to);
  }
  
  void updateSorting(String? sortBy, String? sortOrder) {
    state = state.copyWith(sortBy: sortBy, sortOrder: sortOrder);
  }
  
  void reset() {
    state = CarFilters();
  }
}

// Filter Provider
final carFiltersNotifierProvider = StateNotifierProvider<CarFiltersNotifier, CarFilters>((ref) {
  return CarFiltersNotifier();
});

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

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider));
});

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

  void logout() {
    state = AuthState();
  }
}

// Mock data helper
List<Car> _getMockCars() {
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
  ];
} 