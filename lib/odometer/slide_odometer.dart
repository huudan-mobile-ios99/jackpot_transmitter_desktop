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

  Widget transitionOut(int value, int place, double animation) => Transform.translate(
        offset: Offset(0, verticalOffset * -animation),
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
        offset: Offset(0, verticalOffset * (1.0 - animation)),
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
            SizedBox(
              width: place == 0 ? letterWidth * 0.5 : letterWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  transitionOut(digitValue, place, progress),
                  transitionIn((digitValue + 1) % 10, place, progress),
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




// import 'package:flutter/material.dart';
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

//   Widget spinningColumn(int currentValue, double progress) {
//     final previousValue = (currentValue - 1) < 0 ? 9 : (currentValue - 1);
//     final nextValue = (currentValue + 1) % 10;
//     final digitHeight = verticalOffset * 2.0; // 97.5px for font (65px) and shadows

//     // Calculate offset to center the current digit
//     // SizedBox height = digitHeight * 4 = 390px, center at 195px
//     // Current digit (second in column) center at digitHeight + digitHeight / 2 = 146.25px
//     final baseOffset = -(digitHeight * 0.5); // Center current digit, adjusted to show next digit
//     final progressOffset = -progress * digitHeight; // Slide up as progress increases
//     final totalOffset = baseOffset + progressOffset;

//     // Debug logging to verify digit positions
//     print('Hundredths: [next: $nextValue, current: $currentValue, previous: $previousValue], Progress: $progress, Offset: $totalOffset');

//     return ClipRect(
//       child: SizedBox(
//         width: letterWidth,
//         height: digitHeight * 5, // 390px to ensure all digits are visible
//         child: Container(
//           color: Colors.blue.withOpacity(0.2), // Debug background
//           child: Transform.translate(
//             offset: Offset(0, totalOffset),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Next digit (above)
//                 SizedBox(
//                   height: digitHeight,
//                   child: Text(
//                     '$nextValue',
//                     textAlign: TextAlign.center,
//                     style: numberTextStyle,
//                   ),
//                 ),
//                 // Current digit (center)
//                 SizedBox(
//                   height: digitHeight,
//                   child: Text(
//                     '$currentValue',
//                     textAlign: TextAlign.center,
//                     style: numberTextStyle,
//                   ),
//                 ),
//                 // Previous digit (below)
//                 SizedBox(
//                   height: digitHeight,
//                   child: Text(
//                     '$previousValue',
//                     textAlign: TextAlign.center,
//                     style: numberTextStyle,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

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

//           if (place == -2) {
//             // Hundredths place: use spinning column
//             children.add(spinningColumn(digitValue, progress));
//           } else {
//             // Other places: use original sliding transition
//             children.add(
//               SizedBox(
//                 width: place == 0 ? letterWidth * 0.5 : letterWidth,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     transitionOut(digitValue, place, progress),
//                     transitionIn((digitValue + 1) % 10, place, progress),
//                   ],
//                 ),
//               ),
//             );
//           }
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
