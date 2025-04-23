import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer_custom.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number_custom.dart';

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

  final OdometerNumberCustom odometerNumber;
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
      (dynamic value) => OdometerTween(begin: value as OdometerNumberCustom),
    ) as OdometerTween?;
  }

  @override
  Widget build(BuildContext context) {
    return OdometerCustom(
      transitionOut: widget.transitionOut,
      transitionIn: widget.transitionIn,
      odometerNumber: _odometerTween!.evaluate(animation),
    );
  }
}


class OdometerTransition extends AnimatedWidget {
  const OdometerTransition({
    Key? key,
    required this.transitionIn,
    required this.transitionOut,
    required Animation<OdometerNumberCustom> odometerAnimation,
  }) : super(key: key, listenable: odometerAnimation);

  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;

  Animation<OdometerNumberCustom> get odometerAnimation =>
      listenable as Animation<OdometerNumberCustom>;

  @override
  Widget build(BuildContext context) {
    return OdometerCustom(
      transitionOut: transitionOut,
      transitionIn: transitionIn,
      odometerNumber: odometerAnimation.value,
    );
  }
}
