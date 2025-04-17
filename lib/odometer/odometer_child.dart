import 'dart:math';
import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/color_custom.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';

class DynamicSpeedCurve extends Curve {
  final double difference;

  DynamicSpeedCurve(this.difference);

  @override
  double transformInternal(double t) {
    final speedFactor = (difference / 20.0).clamp(0.5, 2.0);
    final adjustedT = t * speedFactor;
    return Curves.easeInOut.transform(adjustedT.clamp(0.0, 1.0));
  }
}

class GameOdometerChild extends StatefulWidget {
  final double startValue;
  final double endValue;

  const GameOdometerChild({
    Key? key,
    required this.startValue,
    required this.endValue,
  }) : super(key: key);

  @override
  _GameOdometerChildState createState() => _GameOdometerChildState();
}

class _GameOdometerChildState extends State<GameOdometerChild>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<OdometerNumber> odometerAnimation;
  final double fontSize = 75;
  final String fontFamily = 'Poppins';

  Duration _calculateDuration(double startValue, double endValue) {
    return const Duration(seconds: 3);
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    controller.forward();
  }

  void _initializeAnimations() {
    // Normalize start/end values
    double startValue = widget.startValue.isNaN || widget.startValue.isInfinite
        ? 0.0
        : double.parse(widget.startValue.toStringAsFixed(2));
    double endValue = widget.endValue.isNaN || widget.endValue.isInfinite
        ? 0.0
        : double.parse(widget.endValue.toStringAsFixed(2));

    // Debug input values and digits
    debugPrint('startValue: $startValue, endValue: $endValue');
    final startOdometer = OdometerNumber(startValue);
    final endOdometer = OdometerNumber(endValue);
    debugPrint('startDigits: ${startOdometer.digits} (decimal: ${startOdometer.digits[-2]}.${startOdometer.digits[-1]})');
    debugPrint('endDigits: ${endOdometer.digits} (decimal: ${endOdometer.digits[-2]}.${endOdometer.digits[-1]})');

    final duration = _calculateDuration(startValue, endValue);
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    final difference = (endValue - startValue).abs();
    odometerAnimation = OdometerTween(
      begin: OdometerNumber(startValue),
      end: OdometerNumber(endValue),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: DynamicSpeedCurve(difference),
      ),
    )..addListener(() {
        // Debug digits during animation
        final current = odometerAnimation.value;
        print('Animation Digits (t=${controller.value.toStringAsFixed(2)}): ${current.digits} (decimal: ${current.digits[-2]}.${current.digits[-1]})');
      });
  }

  @override
  void didUpdateWidget(covariant GameOdometerChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue ||
        widget.endValue != oldWidget.endValue) {
      controller.dispose();
      _initializeAnimations();
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letterWidth = fontSize * 0.75;
    final verticalOffset = -fontSize * 0.7;

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "\$",
              style: TextStyle(
                fontSize: fontSize,
                color: ColorCustom.yellow_gradient3,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8.0),
            SlideOdometerTransition(
              verticalOffset: verticalOffset,
              groupSeparator: Text(
                ',',
                style: TextStyle(
                  fontSize: fontSize,
                  color: ColorCustom.yellow_gradient3,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              letterWidth: letterWidth,
              odometerAnimation: odometerAnimation,
              numberTextStyle: TextStyle(
                fontSize: fontSize,
                color: ColorCustom.yellow_gradient3,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    color: Colors.white10,
                    offset: Offset(16, 16),
                    blurRadius: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
