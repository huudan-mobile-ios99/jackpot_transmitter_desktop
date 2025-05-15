import 'package:flutter_bloc/flutter_bloc.dart';
import 'jackpot_event.dart';
import 'jackpot_state.dart';

class JackpotBloc extends Bloc<JackpotEvent, JackpotState> {
  JackpotBloc() : super(JackpotState.initial()) {
    on<JackpotReceived>(_onJackpotReceived);
  }

  void _onJackpotReceived(JackpotReceived event, Emitter<JackpotState> emit) {
    emit(state.copyWith(
      id: event.id,
      name: event.name,
      value: event.value,
      machineNumber: event.machineNumber,
      status: event.status,
      connectionStatus: 'Connected',
    ));
  }
}
