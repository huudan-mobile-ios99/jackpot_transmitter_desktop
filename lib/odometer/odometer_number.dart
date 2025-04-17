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
    digits[-2] = (decimalPart % 10).toDouble(); // Tens (e.g., 6 for 0.60)
    digits[-1] = (decimalPart ~/ 10).toDouble(); // Units (e.g., 0 for 0.60)
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
    // Include only necessary places
    for (var i = -2; i <= maxPlaces; i++) {
      final startValue = start.digits[i] ?? 0.0;
      final endValue = end.digits[i] ?? 0.0;
      // Accelerate decimal digits
      final adjustedT = i < 0 ? t * 1.5 : t;
      final interpolated = lerpDouble(startValue, endValue, adjustedT.clamp(0.0, 1.0))!;
      // Skip leading zeros unless necessary
      if (i > 0 && interpolated == 0 && i > maxPlaces) continue;
      digits[i] = interpolated;
    }
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
