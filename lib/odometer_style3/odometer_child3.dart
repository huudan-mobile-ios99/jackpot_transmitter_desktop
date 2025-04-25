import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_number3.dart';
import 'package:playtech_transmitter_app/odometer_style3/slide_odometer3.dart';

class GameOdometerChildStyle3 extends StatefulWidget {
  final double startValue;

  const GameOdometerChildStyle3({
    Key? key,
    required this.startValue,
  }) : super(key: key);

  @override
  _GameOdometerChildStyle3State createState() => _GameOdometerChildStyle3State();
}

class _GameOdometerChildStyle3State extends State<GameOdometerChildStyle3>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> odometerAnimation;

  late double currentValue;
  final double fontSize = 125;
  final String fontFamily = 'Poppins';
  final textStyle = const TextStyle(
    fontSize: 125,
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.orangeAccent,
        offset: Offset(0, 2.5),
        blurRadius: 16,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    currentValue = widget.startValue;
    _initializeAnimation(currentValue, currentValue);
  }

  void _initializeAnimation(double start, double end) {
    const duration = Duration(milliseconds: 150);
    animationController = AnimationController(
      duration: duration,
      vsync: this,
    );

    odometerAnimation = OdometerTween(
      begin: OdometerNumber((start * 100).round()), // Scale for two decimal places
      end: OdometerNumber((end * 100).round()),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
  }

  void _incrementValue() {
    setState(() {
      final nextValue = currentValue + 0.01; // Increment by 0.01
      animationController.dispose();
      _initializeAnimation(currentValue, nextValue);
      currentValue = nextValue;
      animationController.forward(from: 0.0);
    });
  }

  @override
  void didUpdateWidget(covariant GameOdometerChildStyle3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue) {
      setState(() {
        currentValue = widget.startValue;
        animationController.dispose();
        _initializeAnimation(currentValue, currentValue);
        animationController.forward(from: 0.0);
      });
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
    final verticalOffset = fontSize * 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRect(
          child: Container(
            alignment: Alignment.center,
            width: 1000.0,
            height: 145.5,
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
                        decimalSeparator: Text('', style: textStyle),
                        letterWidth: letterWidth,
                        odometerAnimation: odometerAnimation,
                        numberTextStyle: textStyle,
                        decimalPlaces: 2, // Show two decimal places
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _incrementValue,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
