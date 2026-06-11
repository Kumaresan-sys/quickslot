import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart';

abstract class SlotUpdateSource {
  Stream<Map<String, dynamic>> get slotUpdates;

  void holdSlot({
    required String venueId,
    required String slotId,
    required String date,
    required String userId,
  });

  void releaseSlot({
    required String venueId,
    required String slotId,
    required String date,
    required String userId,
  });
}

class SocketClient implements SlotUpdateSource {
  Socket? _socket;
  final String url;

  // Stream to broadcast slot updates to UI
  final _slotUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  @override
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

  @override
  void holdSlot({
    required String venueId,
    required String slotId,
    required String date,
    required String userId,
  }) {
    _socket?.emit('slot_hold', {
      'venueId': venueId,
      'slotId': slotId,
      'date': date,
      'userId': userId,
    });
  }

  @override
  void releaseSlot({
    required String venueId,
    required String slotId,
    required String date,
    required String userId,
  }) {
    _socket?.emit('slot_release', {
      'venueId': venueId,
      'slotId': slotId,
      'date': date,
      'userId': userId,
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    _socket?.dispose();
    _slotUpdateController.close();
  }
}
