import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class JackpotPageWebSocketV1 extends StatefulWidget {
  const JackpotPageWebSocketV1({super.key});

  @override
  _JackpotPageWebSocketV1State createState() => _JackpotPageWebSocketV1State();
}

class _JackpotPageWebSocketV1State extends State<JackpotPageWebSocketV1> {
  WebSocketChannel? _channel;
  String _connectionStatus = 'Connecting...';
  String _id = '';
  String _name = '';
  String _value = '';
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 50;
  final String _wsUrl = 'ws://localhost:8088'; // Update to ws://192.168.100.165:8080 if networked

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      setState(() {
        _connectionStatus = 'Max reconnect attempts reached. Using mock data.';
      });
      return;
    }

    if (_isConnecting) {
      debugPrint('Connection already in progress. Skipping.');
      return;
    }

    _isConnecting = true;
    debugPrint('Attempting to connect to $_wsUrl (Attempt ${_reconnectAttempts + 1})');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

      _channel!.stream.listen(
        (message) {
          final receiveTime = DateTime.now();
          debugPrint('Raw message: $message at ${receiveTime.toIso8601String()}');
          setState(() {
            _connectionStatus = 'Connected';
            _reconnectAttempts = 0;
          });

          try {
            final data = jsonDecode(message);
            if (data['type'] == 'frequent_jp_drop') {
              final jackpotData = data['data'] ?? {};
              setState(() {
                _id = jackpotData['Id']?.toString() ?? '';
                _name = jackpotData['Name']?.toString() ?? '';
                _value = jackpotData['Value']?.toString() ?? '';
              });
              debugPrint('Parsed jackpot: Id=$_id, Name=$_name, Value=$_value');
            }
          } catch (e, stackTrace) {
            debugPrint('Error parsing message: $e');
            debugPrint('Stack trace: $stackTrace');
          }
        },
        onDone: () {
          debugPrint('WebSocket closed');
          setState(() {
            _connectionStatus = 'Disconnected. Reconnecting...';
            _id = '';
            _name = '';
            _value = '';
          });
          _scheduleReconnect();
        },
        onError: (error, stackTrace) {
          debugPrint('WebSocket error: $error');
          debugPrint('Stack trace: $stackTrace');
          setState(() {
            _connectionStatus = 'Error: $error';
            _id = '';
            _name = '';
            _value = '';
          });
          _scheduleReconnect();
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Failed to connect to WebSocket: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _connectionStatus = 'Error: $e';
      });
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _scheduleReconnect() {
    if (_reconnectTimer?.isActive ?? false) {
      debugPrint('Reconnect timer already active. Skipping.');
      return;
    }

    _reconnectAttempts++;
    debugPrint('Scheduling reconnect in 1 second (Attempt $_reconnectAttempts)');
    _reconnectTimer = Timer(const Duration(seconds: 1), () {
      _connectWebSocket();
    });
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
            width: 600,
            padding: const EdgeInsets.all(24.0),
            decoration:const BoxDecoration(
            ),
            child: Text('$_connectionStatus - ID: $_id - Name: $_name Value: $_value',style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        JackpotDisplay()
      ],
    );
  }
}
