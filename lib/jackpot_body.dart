import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer_calculator.dart';
import 'package:playtech_transmitter_app/odometer_style2/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer_style2/slide_odometer.dart';

class JackpotBodyPage extends StatefulWidget {
  final double startValue;
  final double endValue;
  final String nameJP;

  const JackpotBodyPage({
    Key? key,
    required this.startValue,
    required this.endValue,
    required this.nameJP,
  }) : super(key: key);

  @override
  _JackpotBodyPageState createState() => _JackpotBodyPageState();
}

class _JackpotBodyPageState extends State<JackpotBodyPage> with TickerProviderStateMixin {
  final double fontSize = 75;
  final int durationCircle = 30000; //30000ms = 30s
  final String fontFamily = 'OpenSans';
  final textStyle = const TextStyle(
    fontSize: 75,
    color: Colors.white,
    fontFamily: 'OpenSans',
  );

  late int startInt;
  late int endInt;
  late int startDecimal;
  late int endDecimal;
  late double startNumber;
  late double endNumber;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Initialize integer and decimal parts
    startInt = widget.startValue.truncate();
    startDecimal = ((widget.startValue - startInt) * 100).round();
    endInt = widget.endValue.truncate();
    endDecimal = ((widget.endValue - endInt) * 100).round();
    // Correctly convert to a decimal number (e.g., 324.91 -> 324.91)
    startNumber = (startInt * 100 + startDecimal) / 100.0;
    endNumber = (endInt * 100 + endDecimal) / 100.0;
    getSecondDecimalIncrementDuration(startValue: startNumber, endValue: endNumber, totalDurationMs: durationCircle);
  }

  @override
  void didUpdateWidget(covariant JackpotBodyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue || widget.endValue != oldWidget.endValue) {
      _initializeAnimation(); // Reinitialize with new values
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        alignment: Alignment.center,
        width: 1000,
        height: 400,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('S: $startNumber $startInt $startDecimal', style: textStyle),
              const SizedBox(height: 8),
              Text('E: $endNumber $endInt $endDecimal', style: textStyle),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}

 double getSecondDecimalIncrementDuration({
    required double startValue,
    required double endValue,
    required int totalDurationMs,
  }) {
    // Convert to integer representation
    final startInt = startValue.truncate();
    final startDecimal = ((startValue - startInt) * 100).round();
    final endInt = endValue.truncate();
    final endDecimal = ((endValue - endInt) * 100).round();
    final startNumber = startInt * 100 + startDecimal;
    final endNumber = endInt * 100 + endDecimal;
    // Total increments
    final totalIncrements = endNumber - startNumber;
    // Duration per increment
    final durationPerIncrement = totalDurationMs / totalIncrements;
    debugPrint('getSecondDecimalIncrementDuration: $durationPerIncrement');
    return durationPerIncrement;
  }
