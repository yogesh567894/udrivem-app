import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/car_model.dart';
import '../config.dart';

class SocketService {
  late IO.Socket _socket;
  // Remove onCarLocationUpdate field, use callback in connect

  void connect({required Function(CarModel) onRemoteUpdate}) {
    _socket = IO.io(Config.socketUrl, IO.OptionBuilder()
        .setTransports(['websocket', 'polling'])  // Add polling fallback
        .enableReconnection()
        .setReconnectionAttempts(5)
        .setReconnectionDelay(2000)
        .setTimeout(20000)
        .build());

    _socket.onConnect((_) {
      print('✅ Socket connected successfully');
      _socket.emit('UpdateSocket', 'flutter-client');
    });

    _socket.on('car_update_location', (data) {
      if (data != null) {
        try {
          final car = CarModel.fromJson(Map<String, dynamic>.from(data));
          onRemoteUpdate(car);
          print('📡 Received car update: ${car.id}');
        } catch (e) {
          print('❌ Socket data error: $e');
        }
      }
    });

    _socket.onDisconnect((_) => print('🔴 Socket disconnected'));
    // Add better error handling
    _socket.onConnectError((error) {
      print('❌ Socket connection error: $error');
    });
  }

  void sendLocation(String carId, double lat, double lng) {
    if (_socket.connected) {
      _socket.emit('car_update_location', {
        'car_id': carId,
        'lat': lat,
        'lng': lng,
      });
      print('📤 Sent location: $carId');
    }
  }

  void dispose() => _socket.dispose();
} 