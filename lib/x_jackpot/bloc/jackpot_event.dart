import 'package:equatable/equatable.dart';

abstract class JackpotEvent extends Equatable {
  const JackpotEvent();
  @override
  List<Object?> get props => [];
}

class JackpotReceived extends JackpotEvent {
  final String id;
  final String name;
  final String value;
  final String machineNumber;
  final int status;

  const JackpotReceived({
    required this.id,
    required this.name,
    required this.value,
    required this.machineNumber,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, value, machineNumber, status];
}
