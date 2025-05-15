import 'dart:math';

import 'package:flutter/material.dart';
class OdometerScreen extends StatefulWidget {
  const OdometerScreen({Key? key}) : super(key: key);

  @override
  State<OdometerScreen> createState() => _OdometerScreenState();
}

class _OdometerScreenState extends State<OdometerScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _unitsController; // First odometer (units digit, right)
  late ScrollController _tensController; // Second odometer (tens digit, left)
  late AnimationController _animationController;
  late Animation<double> _animation;
  final double itemHeight = 60.0; // Height of each number item
  final int numberOfItems = 10; // Numbers 0-9
  int currentUnits = 0; // Current units digit (second digit)
  int currentTens = 0; // Current tens digit (first digit)
  int targetUnits = 0; // Target units digit
  int targetTens = 0; // Target tens digit
  int startValue = 0; // Random start value (10-20)
  int endValue = 0; // Random end value (50-99)
  bool isAnimating = false; // Track animation state
  double animationDuration = 1.0; // Duration per step (seconds)

  @override
  void initState() {
    super.initState();
    // Generate random start and end values
    startValue = Random().nextInt(11) + 10; // 10-20
    endValue = Random().nextInt(50) + 50; // 50-99

    // Initialize current and target digits
    currentTens = startValue ~/ 10; // Tens digit (first digit)
    currentUnits = startValue % 10; // Units digit (second digit)
    targetTens = endValue ~/ 10; // Target tens digit
    targetUnits = endValue % 10; // Target units digit

    // Calculate number of animation steps
    int steps = 0;
    int tempTens = currentTens;
    int tempUnits = currentUnits;
    while (tempTens != targetTens || tempUnits != targetUnits) {
      if (tempTens < 9) {
        tempTens = 9;
        tempUnits = (tempUnits + 1) % 10;
      } else {
        tempTens = 0;
        tempUnits = (tempUnits + 1) % 10;
      }
      steps++;
    }
    animationDuration = 10.0 / steps; // Total 10 seconds divided by steps

    // Initialize scroll controllers
    _unitsController = ScrollController(
      initialScrollOffset: currentUnits * itemHeight,
    );
    _tensController = ScrollController(
      initialScrollOffset: currentTens * itemHeight,
    );

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (animationDuration * 1000).round()),
    );

    // Initialize animation with a dummy value
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut, // Smooth deceleration
      ),
    );
  }

  // Function to animate the odometers
  void startOdometer() async {
    if (isAnimating) return; // Prevent multiple animations
    setState(() {
      isAnimating = true;
    });

    // Continue until current digits match target digits
    while (currentTens != targetTens || currentUnits != targetUnits) {
      // Step 1: Determine targets for this step
      int tensTarget = currentTens < 9 ? 9 : 0;
      int unitsTarget = (currentUnits + 1) % 10;
      if (currentTens == targetTens && unitsTarget > targetUnits) {
        tensTarget = targetTens; // Stop at target tens
        unitsTarget = targetUnits; // Stop at target units
      }

      // Step 2: Animate tens odometer (second odometer, left)
      double tensCurrentOffset = currentTens * itemHeight;
      double tensTargetOffset =
          (tensTarget + (tensTarget <= currentTens ? 10 : 0)) * itemHeight;

      // Step 3: Animate units odometer (first odometer, right)
      double unitsCurrentOffset = currentUnits * itemHeight;
      double unitsTargetOffset =
          (unitsTarget + (unitsTarget <= currentUnits ? 10 : 0)) * itemHeight;

      // Animate both odometers simultaneously
      _animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
      );

      double tensStart = tensCurrentOffset;
      double tensEnd = tensTargetOffset;
      double unitsStart = unitsCurrentOffset;
      double unitsEnd = unitsTargetOffset;

      _animation.addListener(() {
        double t = _animation.value;
        double tensOffset = tensStart + (tensEnd - tensStart) * t;
        double unitsOffset = unitsStart + (unitsEnd - unitsStart) * t;

        // Handle wrap-around for tens odometer
        double maxOffset = (numberOfItems - 1) * itemHeight; // Offset at 9
        if (tensOffset >= maxOffset + itemHeight) {
          tensOffset -= numberOfItems * itemHeight;
        }
        _tensController.jumpTo(tensOffset);

        // Handle wrap-around for units odometer
        if (unitsOffset >= maxOffset + itemHeight) {
          unitsOffset -= numberOfItems * itemHeight;
        }
        _unitsController.jumpTo(unitsOffset);
      });

      _animationController.reset();
      await _animationController.forward();

      // Update current digits
      currentTens = tensTarget;
      currentUnits = unitsTarget;

      setState(() {}); // Update UI after each step
    }

    setState(() {
      isAnimating = false;
    });
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _tensController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Odometer container with two odometers
            SizedBox(
              height: 400,
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Second Odometer (tens digit, left)
                  SizedBox(
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomScrollView(
                          controller: _tensController,
                          physics: const NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Container(
                                  height: itemHeight,
                                  alignment: Alignment.center,
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                childCount: numberOfItems,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          height: 2,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  // First Odometer (units digit, right)
                  SizedBox(
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomScrollView(
                          controller: _unitsController,
                          physics: const NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Container(
                                  height: itemHeight,
                                  alignment: Alignment.center,
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                childCount: numberOfItems,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          height: 2,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Start button
            ElevatedButton(
              onPressed: isAnimating ? null : startOdometer,
              child: const Text('Start'),
            ),
            const SizedBox(height: 20),
            // Display current and target values
            Text(
              'Current: $currentTens$currentUnits, Target: $targetTens$targetUnits',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      );
  }
}
