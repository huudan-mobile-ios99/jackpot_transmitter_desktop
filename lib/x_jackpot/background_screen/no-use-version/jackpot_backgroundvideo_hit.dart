import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:video_player/video_player.dart';

class JackpotBackgroundVideoHit extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHit({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHitState createState() => _JackpotBackgroundVideoHitState();
}

class _JackpotBackgroundVideoHitState extends State<JackpotBackgroundVideoHit> {
  late VideoPlayerController _controller;
  final bool useFixedSize = true; // Set to false for dynamic half-screen size
  final numberFormat = NumberFormat('#,##0.00', 'en_US');



  // Map id to video asset paths
  String _getVideoAssetPath(String id) {
    debugPrint('_getVideoAssetPath ${id}');
    switch (id) {
      case '0':
        return 'asset/video/frequent.mpg';
      case '1':
        return 'asset/video/daily.mpg';
      case '2':
        return 'asset/video/dozen.mpg';
      case '3':
        return 'asset/video/weekly.mpg';
      case '4':
        return 'asset/video/vegas.mpg';
      case '18':
        return 'asset/video/high_limit.mpg';
      case '34':
        return 'asset/video/daily_golden.mpg';
      case '35':
        return 'asset/video/tripple.mpg';
      case '45':
        return 'asset/video/high_limit.mpg';
      case '46':
        return 'asset/video/vegas.mpg';
      case '44':
        return 'asset/video/vegas.mpg';

      case '80':
        return 'asset/video/ppochi.mpg';
      case '81':
        return 'asset/video/ppochi.mpg';
      case '88':
        return 'asset/video/ppochi.mpg';
      case '89':
        return 'asset/video/ppochi.mpg';
      case '97':
        return 'asset/video/ppochi.mpg';
      case '98':
        return 'asset/video/ppochi_slot.mpg';
      default:
        return 'asset/video/frequent.mpg'; // Fallback to frequent if id is unknown
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with the selected asset based on id
    _controller = VideoPlayerController.asset(_getVideoAssetPath(widget.id))
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0); // Mute the video sound
        _controller.play();
        _controller.setLooping(true);
      }).catchError((error) {
        debugPrint('Error initializing video: $error');
      });
  }

  @override
  void dispose() {
    // Dispose of the video controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle =  TextStyle(
      fontSize: 80,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 3),
          blurRadius: 4,
        ),
      ],
    );
     const textStyleSmall =  TextStyle(
      fontSize: 32,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
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
          SizedBox(
            width: ConfigCustom.fixWidth,
            height: ConfigCustom.fixHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Video background with border radius
                if (_controller.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0), // Rounded corners
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator()), // Loading indicator
              ],
            ),
          ),
          // Horizontally centered text with manual vertical offset
          widget.value=='0'?Container() : Positioned(
            left: 0,
            right: 0,
            top: 540 / 2.935,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '\$${numberFormat.format(num.parse(widget.value))}',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          widget.number=='0'? Container() : Positioned(
            bottom: 12,
            right: 36,
            child: Text('#${widget.number}', style: textStyleSmall),
          ),
        ],
      ),
    );
  }
}
