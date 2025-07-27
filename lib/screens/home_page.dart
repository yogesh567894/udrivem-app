import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'booking_history_screen.dart';
// 🆕 Add these imports
import '../services/api_service.dart';
import '../services/socket_service.dart';
import '../services/location_service.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🆕 Add these variables
  final ApiService _apiService = ApiService();
  final SocketService _socketService = SocketService();
  final String _myCarId = 'car_${const Uuid().v4()}';
  StreamSubscription<Position>? _locationSubscription;
  
  @override
  void initState() {
    super.initState();
    _initializeTracking(); // 🆕 Add this line
  }

  // 🆕 Add this method
  Future<void> _initializeTracking() async {
    if (await LocationService.requestPermissions()) {
      await _apiService.joinCar(_myCarId);
      _socketService.connect(onRemoteUpdate: (carData) {
        // Handle remote car updates here
        print('Received car update: \\${carData.id}');
      });
      
      _locationSubscription = LocationService.getLocationStream().listen((position) {
        _socketService.sendLocation(_myCarId, position.latitude, position.longitude);
        _apiService.updateLocation(_myCarId, position.latitude, position.longitude);
      });
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel(); // 🆕 Add this line
    _socketService.dispose(); // 🆕 Add this line
    super.dispose();
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.black),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.black),
                title: const Text(
                  'Booking History',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingHistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main yellow background color to match the reference image
    const Color mainColor = Color(0xFFFFB800);

    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Logo and Hamburger Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Udrive',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 32, height: 3, color: Colors.black),
                        const SizedBox(height: 6),
                        Container(width: 32, height: 3, color: Colors.black),
                        const SizedBox(height: 6),
                        Container(width: 32, height: 3, color: Colors.black),
                      ],
                    ),
                    onPressed: () => _showProfileMenu(context),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // Main Headline Text
              const Text(
                'Book your car\nonline in\nminutes and\npick it up at a\nconvenient\nlocation!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              // Find a Vehicle Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Find a Vehicle',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_right_alt, size: 28),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
