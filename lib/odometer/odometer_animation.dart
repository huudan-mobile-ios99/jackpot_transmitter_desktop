import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';

typedef OdometerAnimationTransitionBuilder = Widget Function(
  int value,
  int place,
  double animation,
);

class AnimatedOdometer extends ImplicitlyAnimatedWidget {
  const AnimatedOdometer({
    Key? key,
    required this.odometerNumber,
    required this.transitionIn,
    required this.transitionOut,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final OdometerNumber odometerNumber;
  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;

  @override
  _AnimatedOdometerState createState() => _AnimatedOdometerState();
}

class _AnimatedOdometerState extends AnimatedWidgetBaseState<AnimatedOdometer> {
  OdometerTween? _odometerTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _odometerTween = visitor(
      _odometerTween,
      widget.odometerNumber,
      (dynamic value) => OdometerTween(begin: value as OdometerNumber),
    ) as OdometerTween? ?? OdometerTween(begin: OdometerNumber(0.0));
  }

  @override
  Widget build(BuildContext context) {
    final odometerNumber = _odometerTween?.evaluate(animation) ?? widget.odometerNumber;
    return Odometer(
      transitionOut: widget.transitionOut,
      transitionIn: widget.transitionIn,
      odometerNumber: odometerNumber,
    );
  }
}

class OdometerTransition extends AnimatedWidget {
  const OdometerTransition({
    Key? key,
    required this.transitionIn,
    required this.transitionOut,
    required Animation<OdometerNumber> odometerAnimation,
  }) : super(key: key, listenable: odometerAnimation);

  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;

  Animation<OdometerNumber> get odometerAnimation =>listenable as Animation<OdometerNumber>;

  @override
  Widget build(BuildContext context) {
    return Odometer(
      transitionOut: transitionOut,
      transitionIn: transitionIn,
      odometerNumber: odometerAnimation.value,
    );
  }
}
