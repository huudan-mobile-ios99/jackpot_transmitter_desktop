import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_number3.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_transition3.dart';


class Odometer3 extends StatelessWidget {
  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;
  final OdometerNumber odometerNumber;

  const Odometer3({
    Key? key,
    required this.transitionIn,
    required this.transitionOut,
    required this.odometerNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = odometerNumber.digits.keys.length; i > 0; i--)
          Stack(
            children: [
              transitionOut(
                OdometerNumber.digit(odometerNumber.digits[i]!),
                i,
                OdometerNumber.progress(odometerNumber.digits[i]!),
              ),
              transitionIn(
                OdometerNumber.digit(odometerNumber.digits[i]! + 1),
                i,
                OdometerNumber.progress(odometerNumber.digits[i]!),
              ),
            ],
          ),
      ],
    );
  }
}
