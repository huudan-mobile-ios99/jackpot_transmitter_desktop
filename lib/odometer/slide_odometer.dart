import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';

class SlideOdometerTransition extends StatelessWidget {
  final Animation<OdometerNumber> odometerAnimation;
  final TextStyle numberTextStyle;
  final double letterWidth;
  final double verticalOffset;
  final Widget groupSeparator;

  const SlideOdometerTransition({
    Key? key,
    required this.odometerAnimation,
    required this.numberTextStyle,
    required this.letterWidth,
    required this.verticalOffset,
    required this.groupSeparator,
  }) : super(key: key);

  Widget transitionOut(int value, int place, double animation) => Transform.translate(
        offset: Offset(0, verticalOffset * (1.0 - animation)),
        child: Opacity(
          opacity: 1.0 - animation,
          child: SizedBox(
            width: place == 0 ? letterWidth * 0.5 : letterWidth,
            child: Text(
              place == 0 ? '.' : '$value',
              textAlign: TextAlign.center,
              style: numberTextStyle,
            ),
          ),
        ),
      );

  Widget transitionIn(int value, int place, double animation) => Transform.translate(
        offset: Offset(0, verticalOffset * (2.0 - animation)),
        child: Opacity(
          opacity: animation,
          child: SizedBox(
            width: place == 0 ? letterWidth * 0.5 : letterWidth,
            child: Text(
              place == 0 ? '.' : '$value',
              textAlign: TextAlign.center,
              style: numberTextStyle,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: odometerAnimation,
      builder: (context, _) {
        final digits = odometerAnimation.value.digits;
        final places = digits.keys.toList()..sort((a, b) => b.compareTo(a));

        // Filter out unnecessary leading zeros
        final filteredPlaces = places.where((place) {
          if (place <= 0) return true; // Keep decimal point and decimal digits
          return digits[place]! > 0 || place == 1 || digits[place + 1] != null;
        }).toList();

        final children = <Widget>[];
        int groupCount = 0;

        for (final place in filteredPlaces) {
          final value = digits[place] ?? 0.0;
          final digitValue = OdometerNumber.digit(value);
          final progress = OdometerNumber.progress(value);

          if (place > 0) {
            // Add group separator every three digits
            if (groupCount > 0 && groupCount % 3 == 0) {
              children.add(groupSeparator);
            }
            groupCount++;
          }

          children.add(
            Stack(
              children: [
                transitionOut(digitValue, place, progress),
                transitionIn((digitValue + 1) % 10, place, progress),
              ],
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
