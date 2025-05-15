import 'package:equatable/equatable.dart';

class JackpotState extends Equatable {
  final String id;
  final String name;
  final String value;
  final String machineNumber;
  final int status;
  final String connectionStatus;

  const JackpotState({
    required this.id,
    required this.name,
    required this.value,
    required this.machineNumber,
    required this.status,
    required this.connectionStatus,
  });

  factory JackpotState.initial() => const JackpotState(
        id: '',
        name: '',
        value: '',
        machineNumber: '',
        status: 0,
        connectionStatus: 'Connecting...',
      );

  JackpotState copyWith({
    String? id,
    String? name,
    String? value,
    String? machineNumber,
    int? status,
    String? connectionStatus,
  }) {
    return JackpotState(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      machineNumber: machineNumber ?? this.machineNumber,
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [id, name, value, machineNumber, status, connectionStatus];
}
