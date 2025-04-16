import 'dart:math';

import 'package:flutter/material.dart';
import 'package:odometer/odometer.dart';
import 'package:playtech_transmitter_app/color_custom.dart';

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
  final double fontSize = 150;
  final String fontFamily = 'Poppins';

  // Calculate animation duration based on the difference
  Duration _calculateDuration(double startValue, double endValue) {
    final difference = (endValue - startValue).abs();
    final seconds = (difference / 1000).clamp(2, 5).toInt();
    return Duration(seconds: seconds);
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    controller.forward();
  }

  void _initializeAnimations() {
    // Use full start and end values, fixed to two decimal places
    double startValue = widget.startValue.isNaN
        ? 0.0
        : double.parse(widget.startValue.toStringAsFixed(2));
    double endValue = widget.endValue.isNaN
        ? 0.0
        : double.parse(widget.endValue.toStringAsFixed(2));

    // Handle wrap-around for upward animation
    double adjustedEndValue = endValue;
    final startInteger = startValue.truncate();
    final endInteger = endValue.truncate();
    final startDecimal = startValue - startInteger;
    final endDecimal = endValue - endInteger;
    if (endDecimal < startDecimal && endInteger > startInteger) {
      // Case: Decimal resets (e.g., 312.90 to 313.00)
      adjustedEndValue = endInteger + 1.0; // Roll to next integer
    }

    // Single controller for unified animation
    final duration = _calculateDuration(startValue, endValue);
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    // Full number animation with custom curve to emphasize decimal
    odometerAnimation = OdometerTween(
      begin: OdometerNumber(startValue),
      end: OdometerNumber(adjustedEndValue),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut), // Decimal bias
      ),
    );
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
    // Dynamic letter width and vertical offset based on fontSize
    final letterWidth = fontSize * 0.75;
    final verticalOffset = -fontSize * 0.7; // Negative for bottom-to-top

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dollar sign
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
            // Full number (integer and decimal)
            AnimatedBuilder(
              animation: odometerAnimation,
              builder: (context, child) {
                final odometerNumber = odometerAnimation.value;
                final digits = odometerNumber.digits;

                // Integer digits (positive indices)
                final integerDigits = digits.entries
                    .where((e) => e.key > 0)
                    .map((e) => MapEntry(e.key, e.value))
                    .toList()
                  ..sort((a, b) => b.key.compareTo(a.key)); // Highest place first
                final integerValue = integerDigits.isNotEmpty
                    ? integerDigits.fold<double>(
                        0, (sum, e) => sum + e.value * pow(10, e.key - 1))
                    : 0.0;

                // Decimal digits (-2 and -1)
                final decimalValue = ((digits[-2] ?? 0) * 10 + (digits[-1] ?? 0)).toInt();
                final formattedDecimal = decimalValue.toString().padLeft(2, '0');

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Integer part
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
                      odometerAnimation: AlwaysStoppedAnimation(
                        OdometerNumber(integerValue),
                      ),
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
                    // Decimal point
                    Text(
                      '.',
                      style: TextStyle(
                        fontSize: fontSize,
                        color: ColorCustom.yellow_gradient3,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Decimal part (2 digits)
                    SlideOdometerTransition(
                      verticalOffset: verticalOffset,
                      letterWidth: letterWidth,
                      odometerAnimation: AlwaysStoppedAnimation(
                        OdometerNumber(decimalValue / 100),
                      ),
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
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
