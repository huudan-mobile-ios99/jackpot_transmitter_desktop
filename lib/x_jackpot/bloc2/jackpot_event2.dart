import 'package:equatable/equatable.dart';

abstract class JackpotEvent2 extends Equatable {
  const JackpotEvent2();
  @override
  List<Object?> get props => [];
}

class JackpotHitReceived extends JackpotEvent2 {
  final Map<String, dynamic> hit;
  const JackpotHitReceived(this.hit);
  @override
  List<Object?> get props => [hit];
}

class JackpotInitialConfigReceived extends JackpotEvent2 {
  final Map<String, dynamic> config;
  const JackpotInitialConfigReceived(this.config);
  @override
  List<Object?> get props => [config];
}

class JackpotUpdatedConfigReceived extends JackpotEvent2 {
  final Map<String, dynamic> config;
  const JackpotUpdatedConfigReceived(this.config);
  @override
  List<Object?> get props => [config];
}

class JackpotHideImagePage extends JackpotEvent2 {
  const JackpotHideImagePage();
  @override
  List<Object?> get props => [];
}
