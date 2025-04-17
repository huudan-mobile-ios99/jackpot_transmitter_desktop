// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/widgets.dart';

// class OdometerNumberV1 {
//   final double number;
//   final Map<int, double> digits;

//   OdometerNumberV1(this.number) : digits = generateDigits(number);

//   OdometerNumberV1.fromDigits(this.digits)
//       : number = digits.entries
//             .map((e) => e.value * pow(10, e.key - 1))
//             .fold(0.0, (a, b) => a + b);

//   static Map<int, double> generateDigits(double number) {
//     final digits = <int, double>{};
//     // Normalize to two decimal places
//     final normalized = double.parse(number.toStringAsFixed(2));
//     if (normalized <= 0) {
//       digits[1] = 0.0;
//       digits[0] = 0.0; // Decimal point
//       digits[-1] = 0.0;
//       digits[-2] = 0.0;
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

//   static OdometerNumberV1 lerp(OdometerNumberV1 start, OdometerNumberV1 end, double t) {
//     // Convert to cents for step-by-step animation
//     final startCents = (start.number * 100).round();
//     final endCents = (end.number * 100).round();
//     final totalSteps = (endCents - startCents).abs();
//     final currentStep = (totalSteps * t.clamp(0.0, 1.0)).round();
//     final currentCents = startCents + (endCents > startCents ? currentStep : -currentStep);

//     // Convert current cents to digits
//     final currentValue = currentCents / 100.0;
//     return OdometerNumberV1(currentValue);
//   }

//   @override
//   String toString() => 'OdometerNumberV1 $number';
// }

// class OdometerTween extends Tween<OdometerNumberV1> {
//   OdometerTween({OdometerNumberV1? begin, OdometerNumberV1? end})
//       : super(begin: begin, end: end);

//   @override
//   OdometerNumberV1 transform(double t) {
//     if (t == 0.0) return begin!;
//     if (t == 1.0) return end!;
//     return lerp(t);
//   }

//   @override
//   OdometerNumberV1 lerp(double t) => OdometerNumberV1.lerp(begin!, end!, t);
// }
