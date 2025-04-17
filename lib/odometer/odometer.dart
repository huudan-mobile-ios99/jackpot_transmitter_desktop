import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';

typedef OdometerAnimationTransitionBuilder = Widget Function(
  int value,
  int place,
  double animation,
);

class Odometer extends StatelessWidget {
  final OdometerNumber odometerNumber;
  final OdometerAnimationTransitionBuilder transitionIn;
  final OdometerAnimationTransitionBuilder transitionOut;

  const Odometer({
    Key? key,
    required this.odometerNumber,
    required this.transitionIn,
    required this.transitionOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final digits = odometerNumber.digits;
    final places = digits.keys.toList()..sort((a, b) => b.compareTo(a));
    // Filter out leading zeros for integer part
    final filteredPlaces = <int>[];
    bool hasNonZero = false;
    for (var place in places) {
      if (place <= 0) {
        // Always include decimal point and decimal digits
        filteredPlaces.add(place);
      } else {
        final value = digits[place] ?? 0.0;
        if (value > 0 || hasNonZero || place == 1) {
          // Include non-zero digits, digits after non-zero, or at least place 1
          filteredPlaces.add(place);
          if (value > 0) hasNonZero = true;
        }
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: filteredPlaces.map((place) {
        final value = digits[place] ?? 0.0;
        final digitValue = OdometerNumber.digit(value);
        final progress = OdometerNumber.progress(value);
        return Stack(
          children: [
            transitionOut(digitValue, place, progress),
            transitionIn((digitValue + 1) % 10, place, progress),
          ],
        );
      }).toList(),
    );
  }
}
