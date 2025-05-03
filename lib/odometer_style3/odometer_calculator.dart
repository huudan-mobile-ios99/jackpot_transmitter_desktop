import 'package:flutter/material.dart';

int calculationDurationPerStep({
    required int totalDuration,
    required double startValue,
    required double endValue,
  }) {
    if (endValue <= startValue) {
      return 1000; // Default duration if no animation is needed
    }
    final totalSteps = ((endValue - startValue) / 0.01).ceil();
    final durationMs = (totalDuration * 1000) / totalSteps;
    // debugPrint('calculationDurationPerStep: $durationMs Ms');
    return durationMs.round().clamp(1, 1000);
  }


