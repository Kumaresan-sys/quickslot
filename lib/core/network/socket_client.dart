import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  Socket? _socket;
  final String url;
  
  // Stream to broadcast slot updates to UI
  final _slotUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get slotUpdates => _slotUpdateController.stream;

  SocketClient({required this.url});

  void connect() {
    _socket = io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.onConnect((_) {
      // connected
    });

    _socket?.on('slot_update', (data) {
      _slotUpdateController.add(Map<String, dynamic>.from(data));
    });

    _socket?.onDisconnect((_) {});

    _socket?.connect();
  }

  void disconnect() {
    _socket?.disconnect();
  }
  
  void dispose() {
    _socket?.dispose();
    _slotUpdateController.close();
  }
}
