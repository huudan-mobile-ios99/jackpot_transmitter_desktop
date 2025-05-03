import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_calculator.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_number3.dart';
import 'package:playtech_transmitter_app/odometer_style3/slide_odometer3.dart';
import 'dart:async';



class GameOdometerChildStyle3 extends StatefulWidget {
  final double startValue;
  final double endValue;
  final int totalDuration; // Total duration in seconds (default: 30)
  final String nameJP;

  const GameOdometerChildStyle3({
    Key? key,
    required this.startValue,
    required this.endValue,
    this.totalDuration = 30,
    required this.nameJP,
  }) : super(key: key);

  @override
  _GameOdometerChildStyle3State createState() => _GameOdometerChildStyle3State();
}

class _GameOdometerChildStyle3State extends State<GameOdometerChildStyle3>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> odometerAnimation;
  late double currentValue;
  final double fontSize = 75;
  final String fontFamily = 'imprint';
  late int durationPerStep; // Calculated dynamically
  late int integerDigits=0; // Cache integer digits

  final textStyle = const TextStyle(
    fontSize: 75,
    color: Colors.white,
    fontFamily: 'imprint',
    fontWeight: FontWeight.normal,
    shadows: [
      Shadow(
        color: Colors.orangeAccent,
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  );

  Timer? _animationTimer;


  @override
  void initState() {
    super.initState();
    currentValue = widget.startValue;
    durationPerStep = calculationDurationPerStep(
      totalDuration: widget.totalDuration,
      startValue: widget.startValue,
      endValue: widget.endValue,
    );
    // _initializeAnimationController();
    // _updateAnimation(currentValue, currentValue);
    // _startAutoAnimation();
    if (widget.startValue == 0.0) {
      currentValue = widget.endValue;
    } else {
      currentValue = widget.startValue;
    }
    _initializeAnimationController();
    _updateAnimation(currentValue, currentValue);
    if (widget.startValue != 0.0) {
      _startAutoAnimation();
    }
  }



  void _initializeAnimationController() {
    animationController = AnimationController(
      duration: Duration(milliseconds: durationPerStep),
      vsync: this,
    );
  }

  void _updateAnimation(double start, double end) {
    odometerAnimation = OdometerTween(
      begin: OdometerNumber((start * 100).round()),
      end: OdometerNumber((end * 100).round()),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
  }

  void _startAutoAnimation() {
    const increment = 0.01;
    final interval = Duration(milliseconds: durationPerStep);
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(interval, (timer) {
      if (currentValue >= widget.endValue || !mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        final nextValue = (currentValue + increment).clamp(currentValue, widget.endValue);
        _updateAnimation(currentValue, nextValue);
        currentValue = nextValue;
        animationController.forward(from: 0.0);
      });
    });
  }

  @override
  void didUpdateWidget(covariant GameOdometerChildStyle3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startValue != oldWidget.startValue ||
        widget.endValue != oldWidget.endValue ||
        widget.totalDuration != oldWidget.totalDuration) {
      setState(() {
        _animationTimer?.cancel();
        currentValue = widget.startValue;
        durationPerStep = calculationDurationPerStep(
          totalDuration: widget.totalDuration,
          startValue: widget.startValue,
          endValue: widget.endValue,
        );
        animationController
          ..stop()
          ..duration = Duration(milliseconds: durationPerStep);
        _updateAnimation(currentValue, currentValue);
        animationController.forward(from: 0.0);
        _startAutoAnimation();
      });
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final letterWidth = fontSize * 0.575;
    final verticalOffset = fontSize * 1.35;

    return Column(
      children: [
        ClipRect(
          child: Container(
            alignment: Alignment.center,
            width: 500,
            height: 135,
            decoration: BoxDecoration(
              // color:Colors.white12,
              borderRadius: BorderRadius.circular(28.0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\$', style: textStyle),
                const SizedBox(width: 8),
                RepaintBoundary(
                  child: SlideOdometerTransition(
                    verticalOffset: verticalOffset,
                    groupSeparator: Text(',',style:textStyle),
                    decimalSeparator: Text('.',style:textStyle),
                    letterWidth: letterWidth,
                    odometerAnimation: odometerAnimation,
                    numberTextStyle: textStyle,
                    decimalPlaces: 2,
                    integerDigits:integerDigits
                  ),
                ),
              ],
            ),
          ),
        ),
        // Text('${widget.nameJP}: ${widget.startValue}->${widget.endValue}',style:TextStyle(color:Colors.white))
      ],
    );
  }
}
