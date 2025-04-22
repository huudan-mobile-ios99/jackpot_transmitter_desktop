// import 'package:flutter/widgets.dart';
// import 'package:playtech_transmitter_app/odometer/odometer_number.dart';

// class SlideOdometerTransition extends StatelessWidget {
//   final Animation<OdometerNumber> odometerAnimation;
//   final TextStyle numberTextStyle;
//   final double letterWidth;
//   final double verticalOffset;
//   final Widget groupSeparator;

//   const SlideOdometerTransition({
//     Key? key,
//     required this.odometerAnimation,
//     required this.numberTextStyle,
//     required this.letterWidth,
//     required this.verticalOffset,
//     required this.groupSeparator,
//   }) : super(key: key);

//   Widget transitionOut(int value, int place, double animation) => Transform.translate(
//         offset: Offset(0, verticalOffset * -animation),
//         child: Opacity(
//           opacity: 1.0 - animation,
//           child: SizedBox(
//             width: place == 0 ? letterWidth * 0.5 : letterWidth,
//             child: Text(
//               place == 0 ? '.' : '$value',
//               textAlign: TextAlign.center,
//               style: numberTextStyle,
//             ),
//           ),
//         ),
//       );

//   Widget transitionIn(int value, int place, double animation) => Transform.translate(
//         offset: Offset(0, verticalOffset * (1.0 - animation)),
//         child: Opacity(
//           opacity: animation,
//           child: SizedBox(
//             width: place == 0 ? letterWidth * 0.5 : letterWidth,
//             child: Text(
//               place == 0 ? '.' : '$value',
//               textAlign: TextAlign.center,
//               style: numberTextStyle,
//             ),
//           ),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: odometerAnimation,
//       builder: (context, _) {
//         final digits = odometerAnimation.value.digits;
//         final places = digits.keys.toList()..sort((a, b) => b.compareTo(a));

//         // Filter out unnecessary leading zeros
//         final filteredPlaces = places.where((place) {
//           if (place <= 0) return true; // Keep decimal point and decimal digits
//           return digits[place]! > 0 || place == 1 || digits[place + 1] != null;
//         }).toList();

//         final children = <Widget>[];
//         int groupCount = 0;

//         for (final place in filteredPlaces) {
//           final value = digits[place] ?? 0.0;
//           final digitValue = OdometerNumber.digit(value);
//           final progress = OdometerNumber.progress(value);

//           if (place > 0) {
//             // Add group separator every three digits
//             if (groupCount > 0 && groupCount % 3 == 0) {
//               children.add(groupSeparator);
//             }
//             groupCount++;
//           }

//           children.add(
//             SizedBox(
//               width: place == 0 ? letterWidth * 0.5 : letterWidth,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   transitionOut(digitValue, place, progress),
//                   transitionIn((digitValue + 1) % 10, place, progress),
//                 ],
//               ),
//             ),
//           );
//         }

//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.baseline,
//           textBaseline: TextBaseline.alphabetic,
//           children: children,
//         );
//       },
//     );
//   }
// }




































import 'package:flutter/widgets.dart';
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

  Widget _buildDigit(int value, double opacity, double offsetY, int place) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: odometerAnimation,
      builder: (context, _) {
        final digits = odometerAnimation.value.digits;
        final places = digits.keys.toList()..sort((a, b) => b.compareTo(a)); // Left-to-right

        // Filter out unnecessary leading zeros
        final filteredPlaces = places.where((place) {
          if (place <= 0) return true; // Keep decimal point and decimal digits
          return digits[place]! > 0 || place == 1 || digits[place + 1] != null;
        }).toList();

        final children = <Widget>[];
        int groupCount = 0;

        for (final place in filteredPlaces) {
          final value = digits[place] ?? 0.0;
          final digitValue = OdometerNumber.digit(value); // Current digit (0-9)
          final progress = OdometerNumber.progress(value); // Transition progress (0.0-1.0)

          if (place > 0) {
            // Add group separator every three digits
            if (groupCount > 0 && groupCount % 3 == 0) {
              children.add(groupSeparator);
            }
            groupCount++;
          }

          if (place == 0) {
            // Static decimal point
            children.add(
              SizedBox(
                width: letterWidth * 0.5,
                child: Text(
                  '.',
                  textAlign: TextAlign.center,
                  style: numberTextStyle,
                ),
              ),
            );
            continue;
          }

          // Calculate digits for the column
          final nextDigit = (digitValue + 1) % 10; // Next digit (e.g., 6 for 5)
          final prevDigit = (digitValue - 1) < 0 ? 9 : (digitValue - 1); // Previous digit (e.g., 4 for 5)

          // Stack for sliding effect with three digits
          children.add(
            SizedBox(
              width: letterWidth,
              height: verticalOffset * 2 , // Enough height for three digits
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none, // Allow digits to be visible outside bounds
                children: [
                  // Previous digit (below)
                  _buildDigit(
                    prevDigit,
                    1.0, // Always visible
                    verticalOffset * (1.0 + progress), // Starts below, moves up
                    place,
                  ),
                  // Current digit (center)
                  _buildDigit(
                    digitValue,
                    1.0, // Always visible
                    verticalOffset * progress, // Starts center, moves up
                    place,
                  ),
                  // Next digit (above)
                  _buildDigit(
                    nextDigit,
                    1.0, // Always visible
                    verticalOffset * (progress - 1.0), // Starts above, moves to center
                    place,
                  ),
                ],
              ),
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: children,
        );
      },
    );
  }
}
