import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';

class OdometerNumber {
  final double number;
  final Map<int, double> digits;

  OdometerNumber(this.number) : digits = generateDigits(number);

  OdometerNumber.fromDigits(this.digits)
      : number = digits.entries
            .map((e) => e.value * pow(10, e.key - 1))
            .fold(0.0, (a, b) => a + b);

  static Map<int, double> generateDigits(double number) {
    final digits = <int, double>{};
    // Normalize to two decimal places
    final normalized = double.parse(number.toStringAsFixed(2));
    if (normalized <= 0) {
      digits[1] = 0.0;
      digits[0] = 0.0; // Decimal point
      digits[-1] = 0.0;
      digits[-2] = 0.0;
      return digits;
    }

    // Use string for decimal part to avoid floating-point errors
    final numberStr = normalized.toStringAsFixed(2);
    final parts = numberStr.split('.');
    final integerPart = int.parse(parts[0]);
    final decimalPart = int.parse(parts[1]); // E.g., "60" -> 60

    // Correct decimal digit assignment
    digits[-1] = (decimalPart ~/ 10).toDouble(); // Tenths (e.g., 0 for 0.60)
    digits[-2] = (decimalPart % 10).toDouble(); // Hundredths (e.g., 6 for 0.60)
    digits[0] = 0.0; // Decimal point

    var v = integerPart;
    var place = 1;
    while (v > 0) {
      digits[place] = (v % 10).toDouble();
      v = v ~/ 10;
      place++;
    }
    return digits;
  }

  static int digit(double value) => (value % 10).truncate();
  static double progress(double value) => value - value.truncate();

  static OdometerNumber lerp(OdometerNumber start, OdometerNumber end, double t) {
    // Determine max integer places needed
    final startInt = start.number.truncate();
    final endInt = end.number.truncate();
    final maxPlaces = max(
      startInt == 0 ? 1 : (log(startInt.abs()) / log(10)).ceil(),
      endInt == 0 ? 1 : (log(endInt.abs()) / log(10)).ceil(),
    );

    final digits = <int, double>{};
    // Handle integer digits
    for (var i = 1; i <= maxPlaces; i++) {
      final startValue = start.digits[i] ?? 0.0;
      final endValue = end.digits[i] ?? 0.0;
      // For decreasing values, simulate increment through 9
      if (endValue < startValue) {
        final diff = (10 - startValue) + endValue;
        final interpolated = (startValue + (diff * t)) % 10;
        digits[i] = interpolated;
      } else {
        digits[i] = lerpDouble(startValue, endValue, t.clamp(0.0, 1.0))!;
      }
    }

    // Handle decimal digits
    final startDecimal = ((start.digits[-1] ?? 0.0) * 10 + (start.digits[-2] ?? 0.0)).toInt();
    final endDecimal = ((end.digits[-1] ?? 0.0) * 10 + (end.digits[-2] ?? 0.0)).toInt();

    if (endDecimal < startDecimal) {
      // Simulate path through 99 for decreasing decimals
      final totalSteps = (100 - startDecimal) + endDecimal;
      final currentStep = (totalSteps * t).toInt();
      final currentDecimal = (startDecimal + currentStep) % 100;

      digits[-1] = (currentDecimal ~/ 10).toDouble();
      digits[-2] = (currentDecimal % 10).toDouble();
    } else {
      // Normal interpolation for increasing decimals
      digits[-1] = lerpDouble(start.digits[-1] ?? 0.0, end.digits[-1] ?? 0.0, t.clamp(0.0, 1.0))!;
      digits[-2] = lerpDouble(start.digits[-2] ?? 0.0, end.digits[-2] ?? 0.0, t.clamp(0.0, 1.0))!;
    }

    digits[0] = 0.0; // Decimal point
    return OdometerNumber.fromDigits(digits);
  }

  @override
  String toString() => 'OdometerNumber $number';
}

class OdometerTween extends Tween<OdometerNumber> {
  OdometerTween({OdometerNumber? begin, OdometerNumber? end})
      : super(begin: begin, end: end);

  @override
  OdometerNumber transform(double t) {
    if (t == 0.0) return begin!;
    if (t == 1.0) return end!;
    return lerp(t);
  }

  @override
  OdometerNumber lerp(double t) => OdometerNumber.lerp(begin!, end!, t);
}
