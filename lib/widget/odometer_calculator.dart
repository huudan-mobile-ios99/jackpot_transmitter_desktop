import 'dart:math';

class OdometerCalculator {
  static Map<String, dynamic> calculateOdometerMetrics({
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
    final durationPerIncrement = totalDurationMs / totalIncrements;

    // Second decimal cycles
    final startSecondDecimal = startDecimal % 10; // 5
    final endSecondDecimal = endDecimal % 10; // 6
    final secondDecimalIncrements = totalIncrements; // 541
    final secondDecimalFullCycles = (secondDecimalIncrements / 10).floor(); // 54
    final secondDecimalPartialIncrements = secondDecimalIncrements % 10; // 1
    final secondDecimalPartialCycle = secondDecimalPartialIncrements / 10; // 0.1
    final secondDecimalTotalCycles = secondDecimalFullCycles + secondDecimalPartialCycle; // 54.1
    final secondDecimalFullCycleDuration = 10 * durationPerIncrement; // 554.53 ms
    final secondDecimalPartialCycleDuration = secondDecimalPartialIncrements * durationPerIncrement; // 55.453 ms

    // First decimal cycles
    final startFirstDecimal = (startDecimal ~/ 10) % 10; // 1
    final endFirstDecimal = (endDecimal ~/ 10) % 10; // 5
    final firstDecimalIncrements = secondDecimalFullCycles; // 54 (carry-overs)
    final firstDecimalFullCycles = (firstDecimalIncrements / 10).floor(); // 5
    final firstDecimalPartialIncrements = firstDecimalIncrements % 10; // 4
    final firstDecimalPartialCycle = firstDecimalPartialIncrements / 10; // 0.4
    final firstDecimalTotalCycles = firstDecimalFullCycles + (firstDecimalPartialIncrements > 0 ? 0 : 0); // 5.0
    final firstDecimalFullCycleDuration = 10 * secondDecimalFullCycleDuration; // 5545.3 ms
    final firstDecimalPartialCycleDuration = firstDecimalPartialIncrements * secondDecimalFullCycleDuration; // 0 ms (included in full cycles)

    // Integer cycles (ones place)
    final startOnes = startInt % 10; // 0
    final endOnes = endInt % 10; // 5
    final onesIncrements = firstDecimalFullCycles; // 5
    final onesFullCycles = (onesIncrements / 10).floor(); // 0
    final onesPartialIncrements = onesIncrements % 10; // 5
    final onesPartialCycle = onesPartialIncrements / 10; // 0.5
    final onesTotalCycles = onesFullCycles + onesPartialCycle; // 0.5
    final onesFullCycleDuration = 10 * firstDecimalFullCycleDuration; // 55453 ms
    final onesPartialCycleDuration = onesPartialIncrements * firstDecimalFullCycleDuration; // 27726.5 ms

    // Integer cycles (tens, hundreds)
    final integerCycles = <int, double>{};
    final integerFullCycleDurations = <int, double>{};
    final integerPartialCycleDurations = <int, double>{};
    var carry = onesIncrements ~/ 10;
    for (int place = 4; place <= 5; place++) {
      final startDigit = (startInt ~/ pow(10, place - 3)) % 10;
      final endDigit = (endInt ~/ pow(10, place - 3)) % 10;
      final increments = carry;
      final fullCycles = (increments / 10).floor();
      final partialIncrements = increments % 10;
      final partialCycle = partialIncrements / 10;
      integerCycles[place] = fullCycles + partialCycle;
      integerFullCycleDurations[place] = 10 * (place == 4 ? onesFullCycleDuration : integerFullCycleDurations[place - 1]!);
      integerPartialCycleDurations[place] = partialIncrements * (place == 4 ? onesFullCycleDuration : integerFullCycleDurations[place - 1]!);
      carry = increments ~/ 10;
    }

    return {
      'startValue':startValue,
      'endValue':endValue,
      'secondDecimal': {
        'fullCycleDuration': secondDecimalFullCycleDuration,
        'partialCycleDuration': secondDecimalPartialCycleDuration,
        'fullCycles': secondDecimalFullCycles,
        'partialCycle': secondDecimalPartialCycle,
        'totalCycles': secondDecimalTotalCycles,
      },
      'firstDecimal': {
        'fullCycleDuration': firstDecimalFullCycleDuration,
        'partialCycleDuration': firstDecimalPartialCycleDuration,
        'fullCycles': firstDecimalFullCycles,
        'partialCycle': firstDecimalPartialCycle,
        'totalCycles': firstDecimalTotalCycles,
      },
      'integer': {
        'ones': {
          'fullCycleDuration': onesFullCycleDuration,
          'partialCycleDuration': onesPartialCycleDuration,
          'fullCycles': onesFullCycles,
          'partialCycle': onesPartialCycle,
          'totalCycles': onesTotalCycles,
        },
        'tens': {
          'fullCycleDuration': integerFullCycleDurations[4],
          'partialCycleDuration': integerPartialCycleDurations[4],
          'fullCycles': integerCycles[4]!.floor(),
          'partialCycle': integerCycles[4]! - integerCycles[4]!.floor(),
          'totalCycles': integerCycles[4],
        },
        'hundreds': {
          'fullCycleDuration': integerFullCycleDurations[5],
          'partialCycleDuration': integerPartialCycleDurations[5],
          'fullCycles': integerCycles[5]!.floor(),
          'partialCycle': integerCycles[5]! - integerCycles[5]!.floor(),
          'totalCycles': integerCycles[5],
        },
      },
      'totalIncrements': totalIncrements,
      'durationPerIncrement': durationPerIncrement,
    };
  }
}
