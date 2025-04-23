// import 'package:flutter/material.dart';
// import 'package:playtech_transmitter_app/color_custom.dart';
// import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
// import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';

// class GameOdometerChild extends StatefulWidget {
//   final double startValue;
//   final double endValue;

//   const GameOdometerChild({
//     Key? key,
//     required this.startValue,
//     required this.endValue,
//   }) : super(key: key);

//   @override
//   _GameOdometerChildState createState() => _GameOdometerChildState();
// }

// class _GameOdometerChildState extends State<GameOdometerChild>
//     with TickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<OdometerNumber> odometerAnimation;
//   final double fontSize = 100;
//   final String fontFamily = 'YoureGone';
//   // final String fontFamily = 'YoureGone';

//   Duration _calculateDuration(double startValue, double endValue) {
//     // Fixed 10-second duration for all animations
//     return const Duration(seconds: 30);
//     // return const Duration(seconds: 30);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     controller.forward();
//   }

//   void _initializeAnimations() {
//     // Normalize start/end values
//     double startValue = widget.startValue.isNaN || widget.startValue.isInfinite
//         ? 0.0
//         : double.parse(widget.startValue.toStringAsFixed(2));
//     double endValue = widget.endValue.isNaN || widget.endValue.isInfinite
//         ? 0.0
//         : double.parse(widget.endValue.toStringAsFixed(2));

//     final duration = _calculateDuration(startValue, endValue);
//     controller = AnimationController(
//       duration: duration,
//       vsync: this,
//     );

//     odometerAnimation = OdometerTween(
//       begin: OdometerNumber(startValue),
//       end: OdometerNumber(endValue),
//     ).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Curves.easeInOut, // Linear curve for consistent speed
//       ),
//     );
//   }

//   @override
//   void didUpdateWidget(covariant GameOdometerChild oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.startValue != oldWidget.startValue ||
//         widget.endValue != oldWidget.endValue) {
//       controller.dispose();
//       _initializeAnimations();
//       controller.forward();
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final letterWidth = fontSize * 0.75;
//     final verticalOffset = fontSize * 0.75;

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.baseline,
//       textBaseline: TextBaseline.alphabetic,
//       children: [
//         Text(
//           "\$",
//           style: TextStyle(
//             fontSize: fontSize,
//             color: ColorCustom.yellow_gradient3,
//             fontFamily: fontFamily,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(width: 8.0),
//         SlideOdometerTransition(
//             verticalOffset: verticalOffset,
//             groupSeparator: Text(
//               ',',
//               style: TextStyle(
//                 fontSize: fontSize,
//                 color: ColorCustom.yellow_gradient3,
//                 fontFamily: fontFamily,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             letterWidth: letterWidth,
//             odometerAnimation: odometerAnimation,
//             numberTextStyle: TextStyle(
//               fontSize: fontSize,
//               color: ColorCustom.yellow_gradient3,
//               fontFamily: fontFamily,
//               fontWeight: FontWeight.bold,
//               shadows: const [
//                 Shadow(
//                   color: Colors.white10,
//                   offset: Offset(16, 16),
//                   blurRadius: 16,
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }





















import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/color_custom.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number_custom.dart';
import 'package:playtech_transmitter_app/odometer/slide_odometer_custom.dart';

class GameOdometerChild extends StatefulWidget {
  final double startValue;
  final double endValue;

  const GameOdometerChild({
    Key? key,
    required this.startValue,
    required this.endValue,
  }) : super(key: key);

  @override
  _GameOdometerChildState createState() => _GameOdometerChildState();
}
class _GameOdometerChildState extends State<GameOdometerChild>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<OdometerNumberCustom> odometerAnimation;
  final double fontSize = 125;
  final String fontFamily = 'YoureGone';
  final  textStyle = TextStyle(
            fontSize: 125,
            color: Colors.white,
            fontFamily: 'YoureGone',
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.orangeAccent,
                offset: Offset(0, 2.5),
                blurRadius: 16,
              ),
            ],
          );

  Duration _calculateDuration(double startValue, double endValue) {
    return const Duration(seconds: 30);    // Fixed 30-second duration for all animations
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    controller.forward();
  }

  void _initializeAnimations() {
    double startValue = widget.startValue.isNaN || widget.startValue.isInfinite
        ? 0.0
        : double.parse(widget.startValue.toStringAsFixed(2));
    double endValue = widget.endValue.isNaN || widget.endValue.isInfinite
        ? 0.0
        : double.parse(widget.endValue.toStringAsFixed(2));

    final duration = _calculateDuration(startValue, endValue);
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    odometerAnimation = OdometerTween(
      begin: OdometerNumberCustom(startValue),
      end: OdometerNumberCustom(endValue),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear, // Smoother transitions
      ),
    );
  }

  @override
  void didUpdateWidget(covariant GameOdometerChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue ||
        widget.endValue != oldWidget.endValue) {
      controller.dispose();
      _initializeAnimations();
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letterWidth = fontSize * 0.6; // Adjusted for better spacing
    final verticalOffset = fontSize * 0.75; // Positive for bottom-to-top

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text("\$", style:textStyle),
        const SizedBox(width: 8.0),
        SlideOdometerTransitionCustom(
            verticalOffset: verticalOffset,
            groupSeparator: Text(
              '',
              style: TextStyle(
                fontSize: fontSize,
                color: ColorCustom.yellow_gradient3,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            letterWidth: letterWidth,
            odometerAnimation: odometerAnimation,
            numberTextStyle:textStyle
          ),
      ],
    );
  }
}
