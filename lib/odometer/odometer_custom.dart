import 'package:flutter/widgets.dart';
import 'package:playtech_transmitter_app/odometer/odometer_animation_custom.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number_custom.dart';

class OdometerCustom extends StatelessWidget {
  final OdometerAnimationTransitionBuilder transitionOut;
  final OdometerAnimationTransitionBuilder transitionIn;
  final OdometerNumberCustom odometerNumber;
  final TextStyle? numberTextStyle;

  const OdometerCustom({
    Key? key,
    required this.transitionIn,
    required this.transitionOut,
    required this.odometerNumber,
    this.numberTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final places = odometerNumber.digits.keys.toList()..sort((a, b) => b.compareTo(a));
    List<Widget> children = [];

    for (int place in places) {
      if (place == 0) {
        children.add(
          SizedBox(
            width: numberTextStyle!.fontSize! * 0.4, // Adjust for decimal point width
            child: Text(
              '.',
              style: numberTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (odometerNumber.digits[place] == -1.0) {
        children.add(
          SizedBox(
            width: numberTextStyle!.fontSize! * 0.6,
            child: Text(
              '-',
              style: numberTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        children.add(
          Stack(
            alignment: Alignment.center,
            children: [
              transitionOut(
                OdometerNumberCustom.digit(odometerNumber.digits[place]!),
                place,
                OdometerNumberCustom.progress(odometerNumber.digits[place]!),
              ),
              transitionIn(
                OdometerNumberCustom.digit(odometerNumber.digits[place]! + 1),
                place,
                OdometerNumberCustom.progress(odometerNumber.digits[place]!),
              ),
            ],
          ),
        );
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
