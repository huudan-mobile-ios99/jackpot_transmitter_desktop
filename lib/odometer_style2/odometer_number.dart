import 'dart:math';
import 'dart:ui';
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
      digits[2] = 0.0;
      digits[3] = 0.0;
      return digits;
    }
    var v = number;
    var place = 1;
    while (v > 0 || place <= 3) {
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

  static OdometerNumber lerp(
    OdometerNumber start,
    OdometerNumber end,
    double t,
  ) {
    final keyLength = max(start.digits.length, end.digits.length);
    final digits = <int, double>{};

    // Calculate increments for each place
    final increments = <int, double>{};
    for (int i = 1; i <= keyLength; i++) {
      final startDigit = start.digits[i] ?? 0.0;
      final endDigit = end.digits[i] ?? 0.0;
      double inc = endDigit - startDigit;
      if (inc < 0) inc += 10; // Handle wrap-around
      increments[i] = inc;
    }

    // Calculate total ticks for carry-over logic
    double totalTicks = 0;
    for (int i = 1; i <= keyLength; i++) {
      double ticks = increments[i]!;
      for (int j = 1; j < i; j++) {
        ticks *= 10; // Higher place requires 10 cycles of lower place
      }
      totalTicks += ticks;
    }

    // Calculate current progress
    final currentProgress = totalTicks * t;
    double remainingProgress = currentProgress;

    for (int i = keyLength; i >= 1; i--) {
      final startDigit = start.digits[i] ?? 0.0;
      double progressForPlace = remainingProgress;
      for (int j = 1; j < i; j++) {
        progressForPlace /= 10; // Divide by 10 for each lower place
      }
      final incrementsDone = progressForPlace.floorToDouble();
      final fractionalProgress = progressForPlace - incrementsDone;
      final currentDigit = (startDigit + incrementsDone) % 10;
      digits[i] = currentDigit + fractionalProgress;
      remainingProgress -= incrementsDone * pow(10, i - 1);
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
