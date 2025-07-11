import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';

// Example: How to use the enhanced providers in your screens

class ExampleUsageScreen extends ConsumerWidget {
  const ExampleUsageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enhanced Providers Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Using carsProvider with filters
            _buildCarsExample(ref),
            const SizedBox(height: 24),
            
            // Example 2: Using simple filters
            _buildSimpleFiltersExample(ref),
            const SizedBox(height: 24),
            
            // Example 3: Using booking actions
            _buildBookingActionsExample(ref),
            const SizedBox(height: 24),
            
            // Example 4: Using authentication
            _buildAuthExample(ref),
            const SizedBox(height: 24),
            
            // Example 5: Filter controls
            _buildFilterControls(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildCarsExample(WidgetRef ref) {
    final filters = ref.watch(carFiltersProvider);
    final carsAsync = ref.watch(carsProvider(filters));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Cars with Filters',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        carsAsync.when(
          data: (cars) => Text('Found ${cars.length} cars'),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ],
    );
  }

  Widget _buildSimpleFiltersExample(WidgetRef ref) {
    final simpleFilters = {'location': 'Mumbai', 'category': 'SUV'};
    final carsAsync = ref.watch(carsWithSimpleFiltersProvider(simpleFilters));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Cars with Simple Filters',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        carsAsync.when(
          data: (cars) => Text('Found ${cars.length} SUVs in Mumbai'),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ],
    );
  }

  Widget _buildBookingActionsExample(WidgetRef ref) {
    final bookingActions = ref.watch(bookingActionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Booking Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        bookingActions.when(
          data: (_) => const Text('Ready for booking actions'),
          loading: () => const Text('Processing booking...'),
          error: (error, stack) => Text('Booking error: $error'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ref.read(bookingActionsProvider.notifier).createBooking(
              carId: 'car123',
              pickupDate: DateTime.now(),
              dropoffDate: DateTime.now().add(const Duration(days: 3)),
            );
          },
          child: const Text('Create Booking'),
        ),
      ],
    );
  }

  Widget _buildAuthExample(WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Authentication State',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Authenticated: $isAuthenticated'),
        if (authState.error != null) Text('Error: ${authState.error}'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).login('user@example.com', 'password');
          },
          child: const Text('Login'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).logout();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }

  Widget _buildFilterControls(WidgetRef ref) {
    final filtersNotifier = ref.read(carFiltersProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5. Filter Controls',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => filtersNotifier.updateCity('Mumbai'),
              child: const Text('Mumbai'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => filtersNotifier.updateCity('Delhi'),
              child: const Text('Delhi'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => filtersNotifier.updateCarType('SUV'),
              child: const Text('SUV'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => filtersNotifier.clearFilters(),
              child: const Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }
}

// Example: How to use providers in a StatefulWidget
class ExampleStatefulScreen extends ConsumerStatefulWidget {
  const ExampleStatefulScreen({super.key});

  @override
  ConsumerState<ExampleStatefulScreen> createState() => _ExampleStatefulScreenState();
}

class _ExampleStatefulScreenState extends ConsumerState<ExampleStatefulScreen> {
  @override
  void initState() {
    super.initState();
    // You can access providers in initState using ref.read
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(carFiltersProvider.notifier).updateCity('Mumbai');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers for reactive UI
    final cars = ref.watch(carsProvider(CarFilters()));
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Example')),
      body: cars.when(
        data: (carList) => ListView.builder(
          itemCount: carList.length,
          itemBuilder: (context, index) {
            final car = carList[index];
            return ListTile(
              title: Text(car.name),
              subtitle: Text(car.priceDisplay),
              trailing: isLoading ? const CircularProgressIndicator() : null,
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
} 