import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/car.dart';
import '../models/booking.dart';
import '../models/filters.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../models/location.dart';
import '../services/api_service.dart';

// ===== SERVICE PROVIDERS =====
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// ===== FILTER PROVIDERS =====
final carFiltersProvider = StateNotifierProvider<CarFiltersNotifier, CarFilters>((ref) {
  return CarFiltersNotifier();
});

final searchFiltersProvider = StateProvider<Map<String, String?>>((ref) => {});

// ===== CACHE PROVIDERS =====
final carCacheProvider = StateProvider<Map<String, Car>>((ref) => {});
final bookingCacheProvider = StateProvider<Map<String, Booking>>((ref) => {});

// ===== ENHANCED CAR PROVIDERS =====
final carsProvider = FutureProvider.family<List<Car>, CarFilters>((ref, filters) async {
  final apiService = ref.read(apiServiceProvider);
  final cache = ref.read(carCacheProvider.notifier);
  
  try {
    final response = await apiService.getCars(filters: filters);
    final cars = response.data ?? [];
    
    // Cache the cars
    for (final car in cars) {
      cache.state[car.id] = car;
    }
    
    return cars;
  } catch (e) {
    print('⚠️ API failed, using cached data: $e');
    // Return cached cars if available
    final cachedCars = ref.read(carCacheProvider).values.toList();
    if (cachedCars.isNotEmpty) {
      return cachedCars;
    }
    
    // Fallback to mock data
    return _getMockCars();
  }
});

// Enhanced car provider with simple filters
final carsWithSimpleFiltersProvider = FutureProvider.family<List<Car>, Map<String, String?>>((ref, filters) async {
  final carFilters = CarFilters(
    location: filters['location'],
    city: filters['city'],
    carType: filters['category'],
    fuelType: filters['fuel_type'],
    transmission: filters['transmission'],
  );
  
  return ref.watch(carsProvider(carFilters));
});

// Single car provider with caching
final carByIdProvider = FutureProvider.family<Car?, String>((ref, carId) async {
  final apiService = ref.read(apiServiceProvider);
  final cache = ref.read(carCacheProvider);
  
  // Check cache first
  if (cache.containsKey(carId)) {
    return cache[carId];
  }
  
  try {
    final response = await apiService.getCarById(carId);
    final car = response.data;
    
    if (car != null) {
      // Cache the car
      ref.read(carCacheProvider.notifier).state[carId] = car;
    }
    
    return car;
  } catch (e) {
    print('⚠️ Failed to fetch car $carId: $e');
    return null;
  }
});

// ===== ENHANCED BOOKING PROVIDERS =====
final bookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final cache = ref.read(bookingCacheProvider.notifier);
  
  try {
    final response = await apiService.getBookings();
    final bookings = response.data ?? [];
    
    // Cache the bookings
    for (final booking in bookings) {
      cache.state[booking.id] = booking;
    }
    
    return bookings;
  } catch (e) {
    print('⚠️ API failed, using cached bookings: $e');
    // Return cached bookings if available
    final cachedBookings = ref.read(bookingCacheProvider).values.toList();
    if (cachedBookings.isNotEmpty) {
      return cachedBookings;
    }
    
    // Fallback to mock data
    return _getMockBookings();
  }
});

// Booking by status provider
final bookingsByStatusProvider = FutureProvider.family<List<Booking>, BookingStatus>((ref, status) async {
  final allBookings = await ref.watch(bookingsProvider.future);
  return allBookings.where((booking) => booking.status == status).toList();
});

// ===== BOOKING ACTIONS PROVIDER =====
final bookingActionsProvider = StateNotifierProvider<BookingActionsNotifier, AsyncValue<void>>((ref) {
  return BookingActionsNotifier(ref.read(apiServiceProvider));
});

// ===== USER PROVIDERS =====
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

// ===== LOCATION PROVIDERS =====
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

// ===== AUTHENTICATION PROVIDERS =====
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider));
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

// ===== UI STATE PROVIDERS =====
final selectedCarProvider = StateProvider<Car?>((ref) => null);
final selectedBookingProvider = StateProvider<Booking?>((ref) => null);
final isLoadingProvider = StateProvider<bool>((ref) => false);

// ===== NOTIFIER CLASSES =====

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

  void updateAvailability(DateTime? from, DateTime? to) {
    state = state.copyWith(availableFrom: from, availableTo: to);
  }

  void updateSorting(String? sortBy, String? sortOrder) {
    state = state.copyWith(sortBy: sortBy, sortOrder: sortOrder);
  }

  void clearFilters() {
    state = CarFilters();
  }
}

class BookingActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ApiService _apiService;

  BookingActionsNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> createBooking({
    required String carId,
    required DateTime pickupDate,
    required DateTime dropoffDate,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      await _apiService.createBooking(
        carId: carId,
        pickupDate: pickupDate,
        dropoffDate: dropoffDate,
        notes: notes,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    state = const AsyncValue.loading();
    
    try {
      await _apiService.cancelBooking(bookingId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    state = const AsyncValue.loading();
    
    try {
      await _apiService.updateBookingStatus(bookingId, status);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

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

// ===== MOCK DATA HELPERS =====
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

List<Booking> _getMockBookings() {
  return [
    Booking(
      id: '1',
      userId: 'user1',
      carId: '1',
      car: null,
      user: null,
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
  ];
} 