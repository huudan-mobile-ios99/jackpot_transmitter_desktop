import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class JackpotBackground extends StatefulWidget {
  final String number;
  final String value;

  const JackpotBackground({
    super.key,
    required this.number,
    required this.value,
  });

  @override
  _JackpotBackgroundState createState() => _JackpotBackgroundState();
}

class _JackpotBackgroundState extends State<JackpotBackground> {
  final String assetBG = 'asset/video/video_background.mpg';
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with the asset
    _controller = VideoPlayerController.asset(assetBG)
      ..initialize().then((_) {
        // Ensure the first frame is shown after initialization
        setState(() {});
        // Start playing the video
        _controller.play();
        // Loop the video
        _controller.setLooping(true);
      }).catchError((error) {
        // Handle initialization errors
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
    return Container(
      color: Colors.black, // Fallback background color
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video background
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            const Center(child: CircularProgressIndicator()), // Loading indicator
          // Text overlays for number and value
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Machine Number: ${widget.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Value: ${widget.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
