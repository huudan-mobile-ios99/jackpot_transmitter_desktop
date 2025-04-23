import 'package:flutter/material.dart';
import 'package:odometer/odometer.dart';


class GameOdometerChildStyle2 extends StatefulWidget {
  final double startValue1;
  final double endValue1;

  const GameOdometerChildStyle2({
    Key? key,
    required this.startValue1,
    required this.endValue1,

  }) : super(key: key);

  @override
  _GameOdometerChildStyle2State createState() => _GameOdometerChildStyle2State();
}

class _GameOdometerChildStyle2State extends State<GameOdometerChildStyle2>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> animation;
  final double fontSize = 125;
  final String fontFamily = 'YoureGone';
  final  textStyle = const TextStyle(fontSize: 125,color: Colors.white,fontFamily: 'YoureGone',fontWeight: FontWeight.bold, shadows:  [Shadow(color: Colors.orangeAccent,offset: Offset(0, 2.5),blurRadius: 16,),],);

  Duration _calculateDuration(double startValue, double endValue) {
    return const Duration(seconds: 30);
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  void _initializeAnimation() {
    final duration = _calculateDuration(widget.startValue1, widget.endValue1);
    animationController = AnimationController(
      duration: duration,
      vsync: this,
    );

    animation = OdometerTween(
      begin: OdometerNumber(widget.startValue1),
      end: OdometerNumber(widget.endValue1),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Easing.standard,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant GameOdometerChildStyle2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if either the start or end values have changed
    if (widget.startValue1 != oldWidget.startValue1 ||
        widget.endValue1 != oldWidget.endValue1) {
      animationController.dispose(); // Dispose of the old controller
      _initializeAnimation(); // Reinitialize with new values
      animationController.forward(from: 0.0); // Restart the animation
    }

  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letterWidth = fontSize * 0.85; // Adjusted for better spacing
    final verticalOffset = fontSize * 1; // Positive for bottom-to-top

    return ClipRect(
      child: Container(
        alignment: Alignment.center,
        width: 500.0,
        height:145.5,
        decoration: BoxDecoration(
          color:Colors.blue.shade200.withOpacity(.25)
        ),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$',style: textStyle,),
                  SizedBox(width:8,),
                  SlideOdometerTransition(
                                verticalOffset:verticalOffset,
                                groupSeparator:  Text('.',style: textStyle),
                                letterWidth: letterWidth,
                                odometerAnimation: animation,
                                numberTextStyle:  textStyle
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





