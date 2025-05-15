import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class JackpotImagePage extends StatefulWidget {
  final String number;
  final String value;

  const JackpotImagePage({
    super.key,
    required this.number,
    required this.value,
  });

  @override
  _JackpotImagePageState createState() => _JackpotImagePageState();
}

class _JackpotImagePageState extends State<JackpotImagePage> {
  final String assetImage = 'asset/video/image_background.png';
  late VideoPlayerController _controller;
  final pixelRatio = window.devicePixelRatio;

  //Size in physical pixels
  final physicalScreenSize = window.physicalSize;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    final textStyleSmall = const TextStyle(
      fontSize: 28,
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
    return Center(
      child: Stack(
        children: [
          Container(
            width: 960,
            height:540,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: AssetImage(assetImage),fit: BoxFit.cover)),
          ),
          // Center the jackpot value text
          // Horizontally centered text with manual vertical offset
          Positioned(
            left: 0,
            right: 0,
            top: 540/2.85,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '\$${double.parse(widget.value).toStringAsFixed(2)}',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right:36,
            child: Text('${(widget.number)}',style: textStyleSmall,))
        ],
      ),
    );
  }
}
