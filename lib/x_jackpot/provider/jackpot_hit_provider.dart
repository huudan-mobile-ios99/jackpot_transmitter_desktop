import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/x_jackpot/model/jackpot_hit_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;


class JackpotProvider with ChangeNotifier {
  List<JackpotHit> _hits = [];
  String _connectionStatus = 'Connecting...';
  bool _hasError = false;
  WebSocketChannel? _channel;

  List<JackpotHit> get hits => _hits;
  String get connectionStatus => _connectionStatus;
  bool get hasError => _hasError;

  JackpotProvider() {
    connectWebSocket();
    fetchInitialHits();
  }

  void connectWebSocket() async {
    const wsUrl = 'ws://localhost:8081'; // Adjust to your server IP
    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _connectionStatus = 'Connected';
      _hasError = false;
      notifyListeners();

      await _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            print(data);
            if (data['type'] == 'JackpotHit' || data['type'] == 'HotSeatHit') {
              final hit = JackpotHit.fromJson(data);
              _hits.insert(0, hit); // Add new hit at the top
              notifyListeners();
            }
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          _connectionStatus = 'Error: $error';
          _hasError = true;
          notifyListeners();
          reconnect();
        },
        onDone: () {
          _connectionStatus = 'Disconnected. Reconnecting...';
          _hasError = true;
          notifyListeners();
          reconnect();
        },
      );
    } catch (e) {
      _connectionStatus = 'Error: $e';
      _hasError = true;
      notifyListeners();
      reconnect();
    }
  }

  void reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_hasError) {
        _channel?.sink.close();
        connectWebSocket();
      }
    });
  }

  Future<void> fetchInitialHits() async {
    // const apiUrl = 'http://localhost:3002/api/hits'; // Adjust to your server IP
    // try {
    //   final response = await http.get(Uri.parse(apiUrl));
    //   if (response.statusCode == 200) {
    //     final List<dynamic> data = jsonDecode(response.body);
    //     _hits = data.map((json) => JackpotHit.fromJson(json)).toList();
    //     _hits.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
    //     notifyListeners();
    //   } else {
    //     debugPrint('Failed to fetch initial hits: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   debugPrint('Error fetching initial hits: $e');
    // }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
