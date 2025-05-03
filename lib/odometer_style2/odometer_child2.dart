import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer_style2/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer_style2/slide_odometer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class GameOdometerChildStyle2 extends StatefulWidget {
  final double startValue;
  final double endValue;
  final String nameJP;

  const GameOdometerChildStyle2({
    Key? key,
    required this.startValue,
    required this.endValue,
    required this.nameJP,
  }) : super(key: key);

  @override
  _GameOdometerChildStyle2State createState() => _GameOdometerChildStyle2State();
}

class _GameOdometerChildStyle2State extends State<GameOdometerChildStyle2>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> animation;
  final double fontSize = 75;
  final String fontFamily = 'Poppins';
  final textStyle = const TextStyle(
    fontSize: 75,
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.orangeAccent,
        offset: Offset(0, 2.5),
        blurRadius: 4,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    animationController.forward();
  }

  void _initializeAnimation() {
    final duration = Duration(seconds:30);
    animationController = AnimationController(
      duration: duration,
      vsync: this,
    );

    // Convert doubles to integer representation (e.g., 306.53 -> 30653)
    final startInt = widget.startValue.truncate();
    final startDecimal = ((widget.startValue - startInt) * 100).round();
    final endInt = widget.endValue.truncate();
    final endDecimal = ((widget.endValue - endInt) * 100).round();

    final startNumber = startInt * 100 + startDecimal;
    final endNumber = endInt * 100 + endDecimal;

    animation = OdometerTween(
      begin: OdometerNumber(startNumber),
      end: OdometerNumber(endNumber),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant GameOdometerChildStyle2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue ||
        widget.endValue != oldWidget.endValue) {
      animationController.dispose();
      _initializeAnimation();
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letterWidth = fontSize * 0.85;
    final verticalOffset = fontSize * 1.25;

    return ClipRect(
      child: Container(
        alignment: Alignment.center,
        width: 700,
        height: 115,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$', style: textStyle),
                  const SizedBox(width: 8),
                  SlideOdometerTransition(
                    verticalOffset: verticalOffset,
                    groupSeparator: Text(',', style: textStyle),
                    decimalSeparator: Text('.', style: textStyle),
                    letterWidth: letterWidth,
                    odometerAnimation: animation,
                    numberTextStyle: textStyle,
                    decimalPlaces: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


