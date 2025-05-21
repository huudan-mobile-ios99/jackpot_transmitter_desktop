import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'dart:async';

class SocketService {
  socket_io.Socket? _socket;

  final StreamController<Map<String, dynamic>> _dataController =  StreamController.broadcast();
  bool _isConnected = false;

  SocketService();

  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;
  bool get isConnected => _isConnected;

  void connect() {
    _socket = socket_io.io(
      ConfigCustom.urlSocketJPHit,
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setReconnectionDelay(1000)
          .setReconnectionAttempts(double.infinity)
          .build(),
    );

    _socket?.onConnect((_) {
      _isConnected = true;
      debugPrint('Socket connected to  ${ConfigCustom.urlSocketJPHit}');
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      debugPrint('Socket disconnected');
    });

    _socket?.onReconnect((_) {
      debugPrint('Socket reconnected');
      // Request latest data on reconnect
      _socket?.emit('fetch_latest');
    });

    _socket?.onError((error) {
      debugPrint('Socket error: $error');
    });

    _socket?.on('jackpot_hit', (data) {
      if (data is Map<String, dynamic>) {
        _dataController.add(data);
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _dataController.close();
  }
}
