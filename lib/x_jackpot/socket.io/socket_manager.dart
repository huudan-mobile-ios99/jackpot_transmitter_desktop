import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  final String BASEURL = '';
  static final SocketManager _instance = SocketManager._();
  factory SocketManager() {
    return _instance;
  }

  IO.Socket? _socket;
  late StreamController<List<Map<String, dynamic>>> _streamController;
  IO.Socket? get socket => _socket;



  Stream<List<Map<String, dynamic>>> get dataStream => _streamController.stream;


  SocketManager._() {
    _streamController =  StreamController<List<Map<String, dynamic>>>.broadcast();
  }

  void initSocket() {
    debugPrint('initSocket');
    _socket = IO.io(BASEURL, <String, dynamic>{
      // 'autoConnect': false,
      // 'transports': ['websocket'],
      'autoConnect': true, // Auto reconnect
      'reconnection': true, // Enable reconnections
      'reconnectionAttempts': 100, // Number of reconnection attempts
      'reconnectionDelay': 1500, // Delay between reconnections
      'transports': ['websocket'],
    });

    //EVENT DEVICE
    _socket?.on('jackpotHit', (data) {
      debugPrint('jackpotHit JSON: $data');
      // processData(data);
    });



    _socket?.connect();
  }

  void connectSocket() {
    _socket?.connect();
  }

  void disposeSocket() {
    _socket?.disconnect();
    _socket = null;
  }

//process data setting
  void processData(dynamic data) {
    debugPrint('processData');
    for (var jsonData in data) {
      try {
        Map<String, dynamic> data = {
          "remaintime": jsonData['remaintime'],
          "remaingame": jsonData['remaingame'],
          "minbet": jsonData['minbet'],
          "maxbet": jsonData['maxbet'],
          "run": jsonData['run'],
          "lastupdate": jsonData['lastupdate'],
          "gamenumber": jsonData['gamenumber'],
          "roundtext": jsonData['roundtext'],
          "gametext": jsonData['gametext'],
          "buyin": jsonData['buyin']
        };
        _streamController.add([data]);
      } catch (e) {
        debugPrint('Error parsing data setting: $e');
      }
    }
  }


  void emitJackpotHit() {
    _socket?.emit('emitjackpotHit');
  }

}
