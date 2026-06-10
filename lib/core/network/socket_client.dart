import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? _socket;
  final String url;
  
  // Stream to broadcast slot updates to UI
  final _slotUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get slotUpdates => _slotUpdateController.stream;

  SocketClient({required this.url});

  void connect() {
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.onConnect((_) {
      print('WebSocket connected');
    });

    _socket?.on('slot_update', (data) {
      print('Slot update received: $data');
      _slotUpdateController.add(Map<String, dynamic>.from(data));
    });

    _socket?.onDisconnect((_) => print('WebSocket disconnected'));

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
