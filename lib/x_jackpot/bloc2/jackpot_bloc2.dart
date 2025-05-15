import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'jackpot_event2.dart';
import 'jackpot_state2.dart';

class JackpotBloc2 extends Bloc<JackpotEvent2, JackpotState2> {
  final String urlSocket = 'http://30.0.0.56:3002';
  late IO.Socket socket;
  Timer? _imagePageTimer;

  JackpotBloc2() : super(const JackpotState2()) {
    socket = IO.io(urlSocket, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 5000,
    });

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
      emit(state.copyWith(
        isConnected: true,
        error: null, // Clear error on reconnect
      ));
    });

    socket.on('jackpotHit', (data) {
      print('Received jackpot hit: $data');
      add(JackpotHitReceived(data));
    });

    socket.on('initialConfig', (data) {
      // print('initialConfig: $data');
      add(JackpotInitialConfigReceived(data));
    });

    socket.on('updatedConfig', (data) {
      print('updatedConfig: $data');
      add(JackpotUpdatedConfigReceived(data));
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
      emit(state.copyWith(isConnected: false));
    });

    socket.onError((error) {
      print('Socket.IO error: $error');
      emit(state.copyWith(
        error: error.toString(),
        isConnected: false,
      ));
    });

    socket.onReconnect((_) {
      print('Reconnected to Socket.IO server');
      emit(state.copyWith(
        isConnected: true,
        error: null, // Clear error on reconnect
      ));
    });

    socket.onReconnectAttempt((attempt) {
      print('Reconnection attempt #$attempt');
    });

    socket.onReconnectError((error) {
      print('Reconnection error: $error');
    });

    socket.connect();

    on<JackpotHitReceived>((event, emit) {
      final updatedHits = List<Map<String, dynamic>>.from(state.hits)..add(event.hit);
      emit(state.copyWith(
        hits: updatedHits,
        showImagePage: true,
        latestHit: event.hit,
        error: null, // Clear error on new data
      ));
      _imagePageTimer?.cancel();
      _imagePageTimer = Timer(const Duration(seconds: 10), () {
        add(const JackpotHideImagePage());
      });
    });

    on<JackpotInitialConfigReceived>((event, emit) {
      emit(state.copyWith(config: event.config));
    });

    on<JackpotUpdatedConfigReceived>((event, emit) {
      if (event.config.containsKey('status')) {
        final isConnected = event.config['status'] == 'connected';
        emit(state.copyWith(
          isConnected: isConnected,
          error: null, // Clear error on status update
        ));
      } else if (event.config.containsKey('error')) {
        emit(state.copyWith(error: event.config['error']));
      } else {
        emit(state.copyWith(config: event.config));
      }
    });

    on<JackpotHideImagePage>((event, emit) {
      emit(state.copyWith(showImagePage: false));
    });
  }

  @override
  Future<void> close() {
    _imagePageTimer?.cancel();
    socket.disconnect();
    socket.dispose();
    return super.close();
  }
}
