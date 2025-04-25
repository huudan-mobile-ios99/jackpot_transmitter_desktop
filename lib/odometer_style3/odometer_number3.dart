import 'dart:math';
import 'package:flutter/widgets.dart';

class OdometerNumber {
  final int number;
  final Map<int, double> digits;

  OdometerNumber(this.number) : digits = generateDigits(number);

  OdometerNumber.fromDigits(this.digits) : number = digits[1]!.toInt();

  static Map<int, double> generateDigits(int number) {
    final digits = <int, double>{};
    if (number <= 0) {
      digits[1] = 0.0;
      return digits;
    }
    var v = number;
    var place = 1;
    while (v > 0) { // Removed place <= 3 to support larger numbers
      digits[place] = (v % 10).toDouble();
      v = v ~/ 10;
      place++;
    }
    return digits;
  }

  static int digit(double value) => (value % 10).truncate();

  static double progress(double value) {
    final progress = value - value.truncate();
    return progress < 0 ? progress + 1 : progress;
  }

  static OdometerNumber lerp(OdometerNumber start, OdometerNumber end, double t) {
    final keyLength = max(start.digits.length, end.digits.length);
    final digits = <int, double>{};

    // Split animation into two phases: decimal digits first, then integer digits
    double decimalT = (t * 2).clamp(0.0, 1.0); // First half (0 to 0.5)
    double integerT = ((t - 0.5) * 2).clamp(0.0, 1.0); // Second half (0.5 to 1.0)

    for (int i = 1; i <= keyLength; i++) {
      final startDigit = start.digits[i] ?? 0.0;
      final endDigit = end.digits[i] ?? 0.0;
      double inc = endDigit - startDigit;
      if (inc < 0) inc += 10; // Handle wrap-around

      double currentDigit;
      if (i <= 2) {
        // Decimal digits (second and first): Animate in first phase
        currentDigit = startDigit + inc * decimalT;
        if (currentDigit >= 10) currentDigit -= 10;
      } else {
        // Integer digits: Animate in second phase
        currentDigit = startDigit + inc * integerT;
      }
      digits[i] = currentDigit;
    }

    return OdometerNumber.fromDigits(digits);
  }

  @override
  String toString() {
    return 'OdometerNumber $number';
  }
}

class OdometerTween extends Tween<OdometerNumber> {
  OdometerTween({OdometerNumber? begin, OdometerNumber? end})
      : super(begin: begin, end: end);

  @override
  OdometerNumber transform(double t) {
    if (t == 0.0) return begin!;
    if (t == 1.0) {
      if (begin!.digits.keys.length > end!.digits.keys.length) {
        end!.digits.addEntries(
          begin!.digits.keys.toSet().difference(end!.digits.keys.toSet()).map(
                (e) => MapEntry(e, 0),
              ),
        );
      }
      return end!;
    }
    return lerp(t);
  }

  @override
  OdometerNumber lerp(double t) => OdometerNumber.lerp(begin!, end!, t);
}
