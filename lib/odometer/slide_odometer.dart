import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer_animation.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';

class AnimatedSlideOdometerNumber extends StatelessWidget {
  final OdometerNumber odometerNumber;
  final Duration duration;
  final double letterWidth;
  final Widget? groupSeparator;
  final TextStyle? numberTextStyle;
  final double verticalOffset;
  final Curve curve;

  const AnimatedSlideOdometerNumber({
    Key? key,
    required this.odometerNumber,
    required this.duration,
    this.numberTextStyle,
    this.curve = Curves.linear,
    required this.letterWidth,
    this.verticalOffset = 20,
    this.groupSeparator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOdometer(
      curve: curve,
      odometerNumber: odometerNumber,
      transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        animation.toDouble(),
        verticalOffset * animation.toDouble() - verticalOffset,
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
      transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        (1 - animation).toDouble(),
        verticalOffset * animation.toDouble(),
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
      duration: duration,
    );
  }
}

class SlideOdometerTransition extends StatelessWidget {
  final Animation<OdometerNumber> odometerAnimation;
  final double letterWidth;
  final Widget? groupSeparator;
  final TextStyle? numberTextStyle;
  final double verticalOffset;

  const SlideOdometerTransition({
    Key? key,
    required this.odometerAnimation,
    this.numberTextStyle,
    required this.letterWidth,
    this.verticalOffset = 20,
    this.groupSeparator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OdometerTransition(
      odometerAnimation: odometerAnimation,
      transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        animation.toDouble(),
        verticalOffset * animation.toDouble() - verticalOffset,
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
      transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        (1 - animation).toDouble(),
        verticalOffset * animation.toDouble(),
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
    );
  }
}

Widget _buildSlideOdometerDigit(
  int value,
  int place,
  double opacity,
  double offsetY,
  Widget? groupSeparator,
  TextStyle? numberTextStyle,
  double letterWidth,
) {
  // Decimal point at place = 0
  if (place == 0) {
    return SizedBox(
      width: letterWidth,
      child: Text(
        '.',
        style: numberTextStyle,
      ),
    );
  }

  // Comma separator for integer digits, only if next higher place exists and is non-zero
  final d = place - 1;
  if (groupSeparator != null && place > 0 && d != 0 && d % 3 == 0) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _valueText(value, opacity, offsetY, numberTextStyle, letterWidth),
        groupSeparator,
      ],
    );
  }

  return _valueText(value, opacity, offsetY, numberTextStyle, letterWidth);
}

Widget _valueText(
  int value,
  double opacity,
  double offsetY,
  TextStyle? numberTextStyle,
  double letterWidth,
) =>
    Transform.translate(
      offset: Offset(0, offsetY),
      child: Opacity(
        opacity: opacity,
        child: SizedBox(
          width: letterWidth,
          child: Text(
            value.toString(),
            style: numberTextStyle,
          ),
        ),
      ),
    );
