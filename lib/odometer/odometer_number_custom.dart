// import 'dart:math';
// import 'package:flutter/widgets.dart';

// class OdometerNumber {
//   final double number;
//   final Map<int, double> digits;

//   OdometerNumber(this.number) : digits = generateDigits(number);

//   OdometerNumber.fromDigits(this.digits)
//       : number = digits.entries
//             .map((e) => e.value * pow(10, e.key - 1))
//             .fold(0.0, (a, b) => a + b);

//   static Map<int, double> generateDigits(double number) {
//     final digits = <int, double>{};
//     // Normalize to two decimal places
//     final normalized = double.parse(number.toStringAsFixed(2));
//     if (normalized <= 0) {
//       digits[1] = 0.0; // Units
//       digits[0] = 0.0; // Decimal point
//       digits[-1] = 0.0; // Tenths
//       digits[-2] = 0.0; // Hundredths
//       return digits;
//     }

//     // Use string for decimal part to avoid floating-point errors
//     final numberStr = normalized.toStringAsFixed(2);
//     final parts = numberStr.split('.');
//     final integerPart = int.parse(parts[0]);
//     final decimalPart = int.parse(parts[1]); // E.g., "60" -> 60

//     // Decimal digits: -1 for tenths, -2 for hundredths
//     digits[-1] = (decimalPart ~/ 10).toDouble(); // Tenths
//     digits[-2] = (decimalPart % 10).toDouble(); // Hundredths
//     digits[0] = 0.0; // Decimal point

//     var v = integerPart;
//     var place = 1;
//     while (v > 0 || place == 1) {
//       digits[place] = (v % 10).toDouble();
//       v = v ~/ 10;
//       place++;
//     }
//     return digits;
//   }

//   static int digit(double value) => (value % 10).truncate();
//   static double progress(double value) => value - value.truncate();

//   static OdometerNumber lerp(OdometerNumber start, OdometerNumber end, double t) {
//     // Convert to cents for step-by-step animation
//     final startCents = (start.number * 100).round();
//     final endCents = (end.number * 100).round();
//     final totalSteps = (endCents - startCents).abs();
//     final currentStep = (totalSteps * t.clamp(0.0, 1.0)).round();
//     final currentCents = startCents + (endCents > startCents ? currentStep : -currentStep);

//     // Convert current cents to digits
//     final currentValue = currentCents / 100.0;
//     return OdometerNumber(currentValue);
//   }

//   @override
//   String toString() => 'OdometerNumber $number';
// }

// class OdometerTween extends Tween<OdometerNumber> {
//   OdometerTween({OdometerNumber? begin, OdometerNumber? end})
//       : super(begin: begin, end: end);

//   @override
//   OdometerNumber transform(double t) {
//     if (t == 0.0) return begin!;
//     if (t == 1.0) return end!;
//     return lerp(t);
//   }

//   @override
//   OdometerNumber lerp(double t) => OdometerNumber.lerp(begin!, end!, t);
// }






























import 'dart:math';
import 'package:flutter/widgets.dart';

class OdometerNumberCustom {
  final double number;
  final Map<int, double> digits;

  OdometerNumberCustom(this.number) : digits = generateDigits(number);

  OdometerNumberCustom.fromDigits(this.digits)
      : number = digits.entries
            .map((e) => e.value * pow(10, e.key - 1))
            .fold(0.0, (a, b) => a + b);

  static Map<int, double> generateDigits(double number) {
    final digits = <int, double>{};
    final normalized = number.isNaN || number.isInfinite ? 0.0 : double.parse(number.toStringAsFixed(2));
    if (normalized == 0) {
      digits[1] = 0.0;
      digits[0] = 0.0; // Decimal point
      digits[-1] = 0.0;
      digits[-2] = 0.0;
      return digits;
    }

    final numberStr = normalized.toStringAsFixed(2);
    final parts = numberStr.split('.');
    final integerPart = int.parse(parts[0]);
    final decimalPart = int.parse(parts[1]);

    // Decimal digits
    digits[-1] = (decimalPart ~/ 10).toDouble(); // Tenths
    digits[-2] = (decimalPart % 10).toDouble(); // Hundredths
    digits[0] = 0.0; // Decimal point

    // Integer digits
    var v = integerPart.abs();
    var place = 1;
    while (v > 0 || place == 1) {
      digits[place] = (v % 10).toDouble();
      v = v ~/ 10;
      place++;
    }

    if (normalized < 0) {
      digits[place] = -1.0; // Negative sign
    }

    return digits;
  }

  static int digit(double value) => (value % 10).truncate();
  static double progress(double value) => value - value.truncate();

  static OdometerNumberCustom lerp(OdometerNumberCustom start, OdometerNumberCustom end, double t) {
    final startCents = (start.number * 100).round();
    final endCents = (end.number * 100).round();
    final totalSteps = (endCents - startCents).abs();
    final currentStep = (totalSteps * t.clamp(0.0, 1.0)).round();
    final currentCents = startCents + (endCents > startCents ? currentStep : -currentStep);
    final currentValue = currentCents / 100.0;
    return OdometerNumberCustom(currentValue);
  }

  @override
  String toString() => 'OdometerNumber $number';
}

class OdometerTween extends Tween<OdometerNumberCustom> {
  OdometerTween({OdometerNumberCustom? begin, OdometerNumberCustom? end})
      : super(begin: begin, end: end);

  @override
  OdometerNumberCustom transform(double t) {
    if (t == 0.0) return begin!;
    if (t == 1.0) return end!;
    return lerp(t);
  }

  @override
  OdometerNumberCustom lerp(double t) => OdometerNumberCustom.lerp(begin!, end!, t);
}
