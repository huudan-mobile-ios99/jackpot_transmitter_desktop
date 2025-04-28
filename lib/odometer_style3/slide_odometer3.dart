// import 'package:flutter/widgets.dart';

// import 'package:playtech_transmitter_app/odometer_style3/odometer_number3.dart';
// import 'package:playtech_transmitter_app/odometer_style3/odometer_transition3.dart';





// class AnimatedSlideOdometerNumber extends StatelessWidget {
//   final OdometerNumber odometerNumber;
//   final Duration duration;
//   final double letterWidth;
//   final Widget? groupSeparator;
//   final Widget? decimalSeparator;
//   final TextStyle? numberTextStyle;
//   final double verticalOffset;
//   final Curve curve;
//   final int decimalPlaces;

//   const AnimatedSlideOdometerNumber({
//     Key? key,
//     required this.odometerNumber,
//     required this.duration,
//     this.numberTextStyle,
//     this.curve = Curves.linear,
//     required this.letterWidth,
//     this.verticalOffset = 20,
//     this.groupSeparator,
//     this.decimalSeparator,
//     this.decimalPlaces = 0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOdometer(
//       curve: curve,
//       odometerNumber: odometerNumber,
//       transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
//         value,
//         place,
//         animation,
//         verticalOffset * animation - verticalOffset,
//         groupSeparator,
//         decimalSeparator,
//         numberTextStyle,
//         letterWidth,
//         decimalPlaces,
//         odometerNumber,
//       ),
//       transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
//         value,
//         place,
//         1 - animation,
//         verticalOffset * animation,
//         groupSeparator,
//         decimalSeparator,
//         numberTextStyle,
//         letterWidth,
//         decimalPlaces,
//         odometerNumber,
//       ),
//       duration: duration,
//     );
//   }
// }

// class SlideOdometerTransition extends StatelessWidget {
//   final Animation<OdometerNumber> odometerAnimation;
//   final double letterWidth;
//   final Widget? groupSeparator;
//   final Widget? decimalSeparator;
//   final TextStyle? numberTextStyle;
//   final double verticalOffset;
//   final int decimalPlaces;

//   const SlideOdometerTransition({
//     Key? key,
//     required this.odometerAnimation,
//     this.numberTextStyle,
//     required this.letterWidth,
//     this.verticalOffset = 20,
//     this.groupSeparator,
//     this.decimalSeparator,
//     this.decimalPlaces = 0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return OdometerTransition(
//       odometerAnimation: odometerAnimation,
//       transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
//         value,
//         place,
//         animation < 0.02 ? 0.85 + (animation / 0.02) * (1.0 - 0.85) : 1.0,
//         verticalOffset * (1.0 - animation),
//         groupSeparator,
//         decimalSeparator,
//         numberTextStyle,
//         letterWidth,
//         decimalPlaces,
//         odometerAnimation.value,
//       ),
//       transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
//         value,
//         place,
//         animation <= 0.99 ? 1.0 : 1 - ((animation - 0.99) / 0.1).clamp(0.0, 1.0),
//         verticalOffset * (animation * -1),
//         groupSeparator,
//         decimalSeparator,
//         numberTextStyle,
//         letterWidth,
//         decimalPlaces,
//         odometerAnimation.value,
//       ),
//     );
//   }
// }

// Widget _buildSlideOdometerDigit(
//   int value,
//   int place,
//   double opacity,
//   double offsetY,
//   Widget? groupSeparator,
//   Widget? decimalSeparator,
//   TextStyle? numberTextStyle,
//   double letterWidth,
//   int decimalPlaces,
//   OdometerNumber odometerNumber,
// ) {
//   Widget digitWidget = _valueText(value, opacity, offsetY, numberTextStyle, letterWidth);

//   // Calculate number of integer digits
//   int integerDigits = 1;
//   int tempNumber = odometerNumber.number ~/ 100;
//   while (tempNumber > 0) {
//     integerDigits++;
//     tempNumber ~/= 10;
//   }

//   // Place decimal separator after integer digits
//   if (decimalSeparator != null && place == decimalPlaces + integerDigits) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         decimalSeparator,
//         digitWidget,
//       ],
//     );
//   }

//   // Place group separator for integer part
//   final d = place - decimalPlaces - integerDigits;
//   if (groupSeparator != null && place > decimalPlaces + integerDigits && d > 0 && d % 4 == 0) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         digitWidget,
//         groupSeparator,
//       ],
//     );
//   }

//   return digitWidget;
// }

// Widget _valueText(
//   int value,
//   double opacity,
//   double offsetY,
//   TextStyle? numberTextStyle,
//   double letterWidth,
// ) =>
//     Transform.translate(
//       offset: Offset(0, offsetY),
//       child: Opacity(
//         opacity: opacity.clamp(0.5, 1.0),
//         child: SizedBox(
//           width: letterWidth,
//           child: Text(
//             value.toString(),
//             textAlign: TextAlign.center,
//             style: numberTextStyle,
//           ),
//         ),
//       ),
//     );



import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_number3.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_transition3.dart';

class AnimatedSlideOdometerNumber extends StatelessWidget {
  final OdometerNumber odometerNumber;
  final Duration duration;
  final double letterWidth;
  final Widget? groupSeparator;
  final Widget? decimalSeparator;
  final TextStyle? numberTextStyle;
  final double verticalOffset;
  final Curve curve;
  final int decimalPlaces;
  final int integerDigits; // New parameter for cached integer digits

  const AnimatedSlideOdometerNumber({
    Key? key,
    required this.odometerNumber,
    required this.duration,
    this.numberTextStyle,
    this.curve = Curves.linear,
    required this.letterWidth,
    this.verticalOffset = 20,
    this.groupSeparator,
    this.decimalSeparator,
    this.decimalPlaces = 2, // Default to 2 decimal places
    required this.integerDigits, // Required cached integer digits
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOdometer(
      curve: curve,
      odometerNumber: odometerNumber,
      transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        animation,
        verticalOffset * animation - verticalOffset,
        groupSeparator,
        decimalSeparator,
        numberTextStyle,
        letterWidth,
        decimalPlaces,
        integerDigits, // Pass cached integer digits
      ),
      transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        1 - animation,
        verticalOffset * animation,
        groupSeparator,
        decimalSeparator,
        numberTextStyle,
        letterWidth,
        decimalPlaces,
        integerDigits, // Pass cached integer digits
      ),
      duration: duration,
    );
  }
}

class SlideOdometerTransition extends StatelessWidget {
  final Animation<OdometerNumber> odometerAnimation;
  final double letterWidth;
  final Widget? groupSeparator;
  final Widget? decimalSeparator;
  final TextStyle? numberTextStyle;
  final double verticalOffset;
  final int decimalPlaces;
  final int integerDigits; // New parameter for cached integer digits

  const SlideOdometerTransition({
    Key? key,
    required this.odometerAnimation,
    this.numberTextStyle,
    required this.letterWidth,
    this.verticalOffset = 20,
    this.groupSeparator,
    this.decimalSeparator,
    this.decimalPlaces = 2, // Default to 2 decimal places
    required this.integerDigits, // Required cached integer digits
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OdometerTransition(
      odometerAnimation: odometerAnimation,
      transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        animation < 0.02 ? 0.85 + (animation / 0.02) * (1.0 - 0.85) : 1.0,
        verticalOffset * (1.0 - animation),
        groupSeparator,
        decimalSeparator,
        numberTextStyle,
        letterWidth,
        decimalPlaces,
        integerDigits, // Pass cached integer digits
      ),
      transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        animation <= 0.99 ? 1.0 : 1 - ((animation - 0.99) / 0.1).clamp(0.0, 1.0),
        verticalOffset * (animation * -1),
        groupSeparator,
        decimalSeparator,
        numberTextStyle,
        letterWidth,
        decimalPlaces,
        integerDigits, // Pass cached integer digits
      ),
    );
  }
}

Widget _buildSlideOdometerDigit(
  int value,
  int place,
  double opacity,
  double offsetY,
  Widget? groupSeparator,
  Widget? decimalSeparator,
  TextStyle? numberTextStyle,
  double letterWidth,
  int decimalPlaces,
  int integerDigits, // Use cached integer digits
) {
  Widget digitWidget = _valueText(value, opacity, offsetY, numberTextStyle, letterWidth);

  // Place decimal separator after integer digits
  if (decimalSeparator != null && place == integerDigits + decimalPlaces) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        decimalSeparator,
        digitWidget,
      ],
    );
  }

  // Place group separator for integer part
  final d = place - decimalPlaces - integerDigits;
  if (groupSeparator != null && place > decimalPlaces + integerDigits && d > 0 && d % 4 == 0) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        digitWidget,
        groupSeparator,
      ],
    );
  }

  return digitWidget;
}

Widget _valueText(
  int value,
  double opacity,
  double offsetY,
  TextStyle? numberTextStyle,
  double letterWidth,
) =>
    Transform.translate(
      offset: Offset(0, offsetY),
      child: Opacity(
        opacity: opacity.clamp(0.5, 1.0),
        child: SizedBox(
          width: letterWidth,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: numberTextStyle,
          ),
        ),
      ),
    );
