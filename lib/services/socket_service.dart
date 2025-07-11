import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/car_model.dart';
import '../config.dart';

class SocketService {
  late IO.Socket _socket;
  Function(CarModel)? onCarLocationUpdate;

  void connect() {
    _socket = IO.io(Config.socketUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableReconnection()
        .setReconnectionAttempts(5)
        .build());

    _socket.onConnect((_) {
      print('🟢 Socket connected');
      _socket.emit('UpdateSocket', 'flutter-client');
    });

    _socket.on('car_update_location', (data) {
      if (onCarLocationUpdate != null && data != null) {
        try {
          final car = CarModel.fromJson(Map<String, dynamic>.from(data));
          onCarLocationUpdate!(car);
          print('📡 Received car update: ${car.id}');
        } catch (e) {
          print('❌ Socket data error: $e');
        }
      }
    });

    _socket.onDisconnect((_) => print('🔴 Socket disconnected'));
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