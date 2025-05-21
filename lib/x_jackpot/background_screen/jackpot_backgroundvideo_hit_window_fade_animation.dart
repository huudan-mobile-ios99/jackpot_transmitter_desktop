import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

class JackpotBackgroundVideoHitWindowFadeAnimation extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHitWindowFadeAnimation({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHitWindowFadeAnimationState createState() => _JackpotBackgroundVideoHitWindowFadeAnimationState();
}

class _JackpotBackgroundVideoHitWindowFadeAnimationState extends State<JackpotBackgroundVideoHitWindowFadeAnimation>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;
  final NumberFormat _numberFormat = NumberFormat('#,##0.00', 'en_US');
  String? _currentVideoPath;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final double fontSize = 145;

  String getVideoAssetPath(String id) {
    debugPrint('getVideoAssetPath: id=$id');
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
      case '81':
      case '88':
      case '89':
      case '97':
      case '98':
        return 'asset/video/ppochi.mpg';
      default:
        debugPrint('Unknown id: $id, falling back to frequent.mpg');
        return 'asset/video/frequent.mpg';
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Initializing JackpotBackgroundVideoHitWindow');

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: ConfigCustom.switchBetweeScreenDurationForHitScreen),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Initialize player and controller
    _player = Player();
    _controller = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    // Load initial video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideo(getVideoAssetPath(widget.id));
    });
  }

  @override
  void didUpdateWidget(JackpotBackgroundVideoHitWindowFadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      debugPrint('ID changed from ${oldWidget.id} to ${widget.id}');
      _loadVideo(getVideoAssetPath(widget.id));
    }
  }

  Future<void> _loadVideo(String videoPath) async {
    if (_currentVideoPath == videoPath) {
      debugPrint('Video unchanged: $videoPath, skipping load');
      return;
    }

    debugPrint('Loading video: $videoPath');
    _currentVideoPath = videoPath;

    try {
      await _player.open(Media('asset:///$videoPath'), play: false);
      debugPrint('Setting playlist mode and volume');
      await _player.setPlaylistMode(PlaylistMode.loop);
      await _player.setVolume(100.0);
      debugPrint('Playing video');
      await _player.play();

      if (mounted) {
        // Trigger fade-in
        _fadeController.reset();
        await _fadeController.forward();
        debugPrint('Fade-in complete');
      }
    } catch (error) {
      debugPrint('Error loading video: $error');
    }
  }

  @override
  void dispose() {
    debugPrint('Disposing JackpotBackgroundVideoHitWindow');
    _player.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textStyle = TextStyle(
      fontSize: fontSize,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: const [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    );
    const textStyleSmall = TextStyle(
      fontSize: 55,
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

    return Stack(
      fit: StackFit.expand,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Video(
            fill: Colors.black,
            controls: (state) => Container(),
            controller: _controller,
            filterQuality: FilterQuality.none,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: screenSize.height / 2 - fontSize,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              '\$${_numberFormat.format(num.parse(widget.value))}',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          bottom: 26,
          right: 86,
          child: Text(
            '#${widget.number}',
            style: textStyleSmall,
          ),
        ),
      ],
    );
  }
}
