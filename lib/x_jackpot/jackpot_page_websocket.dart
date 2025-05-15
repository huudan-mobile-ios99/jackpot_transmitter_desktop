
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc/jackpot_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc/jackpot_event.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc/jackpot_state.dart';
import 'package:playtech_transmitter_app/x_jackpot/jackpot_background.dart';
import 'package:playtech_transmitter_app/x_jackpot/jackpot_image.dart';
import 'package:playtech_transmitter_app/x_jackpot/jackpot_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class JackpotPageWebSocket extends StatefulWidget {
  const JackpotPageWebSocket({super.key});

  @override
  _JackpotPageWebSocketState createState() => _JackpotPageWebSocketState();
}

class _JackpotPageWebSocketState extends State<JackpotPageWebSocket> {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 100;
  final String _wsUrl = 'ws://localhost:8088';
  bool _useMockData = false;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
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
            _reconnectAttempts = 0;
          });

          try {
            final data = jsonDecode(message);
            if (data['type'] == 'frequent_jp_drop') {
              final jackpotData = data['data'] ?? {};
              context.read<JackpotBloc>().add(JackpotReceived(
                id: jackpotData['Id']?.toString() ?? '',
                name: jackpotData['Name']?.toString() ?? '',
                value: jackpotData['Value']?.toString() ?? '',
                machineNumber: jackpotData['MachineNumber']?.toString() ?? "",
                status: jackpotData['status']?? 0
              ));
              debugPrint('Parsed jackpot: Id=${jackpotData['Id']}, Name=${jackpotData['Name']}, Value=${jackpotData['Value']}');
            }
          } catch (e, stackTrace) {
            debugPrint('Error parsing message: $e');
            debugPrint('Stack trace: $stackTrace');
          }
        },
        onDone: () {
          debugPrint('WebSocket closed');
          context.read<JackpotBloc>().add(const JackpotReceived(
            id: '',
            name: '',
            value: '',
            status: 0,
            machineNumber: ''
          ));
          setState(() {
            _scheduleReconnect();
          });
        },
        onError: (error, stackTrace) {
          debugPrint('WebSocket error: $error');
          debugPrint('Stack trace: $stackTrace');
          context.read<JackpotBloc>().add(const JackpotReceived(
            id: '',
            name: '',
            value: '',
            status: 0,
            machineNumber: ''
          ));
          setState(() {
            _scheduleReconnect();
          });
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Failed to connect to WebSocket: $e');
      debugPrint('Stack trace: $stackTrace');
      context.read<JackpotBloc>().add(const JackpotReceived(
        id: '',
        name: '',
        value: '',
        status: 0,
        machineNumber: ''
      ));
      setState(() {
        _scheduleReconnect();
      });
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
    debugPrint('Scheduling reconnect in 1 second (Attempt ${_reconnectAttempts}');
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
    return BlocBuilder<JackpotBloc, JackpotState>(
      builder: (context, state) {
      return Stack(
      children: [
        // state.status==1? JackpotImagePage(number: state.machineNumber, value: state.value) : JackpotDisplay()
        // JackpotImagePage(number: state.machineNumber, value: state.value)
        JackpotDisplay()
        // Center(
        //   child: Container(
        //     alignment: Alignment.center,
        //     width: 600,
        //     padding: const EdgeInsets.all(24.0),
        //     decoration:const BoxDecoration(
        //     ),
        //     child: Text('${state.connectionStatus}\nID: ${state.id}\nName: ${state.name}\nValue: ${state.value}\nMachine: ${state.machineNumber}\nStatus:${state.status}',style: const TextStyle(fontSize: 14, color: Colors.white),
        //     ),
        //   ),
        // ),

      ],
    );
      },
    );
  }
}

