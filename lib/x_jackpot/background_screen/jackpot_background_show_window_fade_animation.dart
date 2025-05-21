import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/widget/circlar_progress_custom.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_page.dart';

class JackpotBackgroundShowWindowFadeAnimate extends StatefulWidget {
  const JackpotBackgroundShowWindowFadeAnimate({super.key});

  @override
  _JackpotBackgroundShowWindowFadeAnimateState createState() => _JackpotBackgroundShowWindowFadeAnimateState();
}

class _JackpotBackgroundShowWindowFadeAnimateState extends State<JackpotBackgroundShowWindowFadeAnimate>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;
  String? _currentVideoPath;
  bool _isInitialized = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Size? _lastScreenSize; // Cache screen size to reduce rebuilds

  @override
  void initState() {
    super.initState();
    debugPrint('Initializing JackpotBackgroundShowWindowFadeAnimate');
    MediaKit.ensureInitialized();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: ConfigCustom.switchBetweeScreenDuration),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
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
      _loadVideo(ConfigCustom.videoBg);
    });
  }

  Future<void> _loadVideo(String videoPath) async {
    if (_currentVideoPath == videoPath) {
      debugPrint('Video unchanged: $videoPath, skipping load');
      return;
    }

    debugPrint('Loading video: $videoPath');
    try {
      // Pause and reset fade before loading
      await _player.pause();
      _fadeController.reset();
      _currentVideoPath = videoPath;
      await _player.open(Media('asset:///$videoPath'), play: false);
      debugPrint('Setting playlist mode and volume');
      await _player.setPlaylistMode(PlaylistMode.loop);
      await _player.setVolume(0.0); // Muted as per original
      debugPrint('Playing video');
      await _player.play();

      if (mounted) {
        _isInitialized = true;
        // Trigger fade-in
        await _fadeController.forward();
        debugPrint('Fade-in complete');
      }
    } catch (error) {
      debugPrint('Error loading video: $error');
      if (mounted) {
        _isInitialized = false;
        _currentVideoPath = null; // Allow retry
      }
    }
  }

  @override
  void dispose() {
    debugPrint('Disposing JackpotBackgroundShowWindowFadeAnimate');
    _player.pause(); // Minimize texture churn
    _player.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Skip rebuild if screen size is stable
    if (_lastScreenSize != null &&
        (_lastScreenSize!.width - screenSize.width).abs() < 1.0 &&
        (_lastScreenSize!.height - screenSize.height).abs() < 1.0) {
      debugPrint('Screen size unchanged, skipping layout rebuild');
    } else {
      _lastScreenSize = screenSize;
      debugPrint('Screen size updated: ${screenSize.width}x${screenSize.height}');
    }

    return BlocBuilder<VideoBloc, ViddeoState>(
      builder: (context, state) {
        debugPrint('BlocBuilder state: id=${state.id}, video=${state.currentVideo}');
        // Load video only if path changes
        if (_currentVideoPath != state.currentVideo) {
          _loadVideo(state.currentVideo);
        }

        return Center(
          child: AspectRatio(
            aspectRatio: ConfigCustom.fixWidth / ConfigCustom.fixHeight, // 16/9
            child: Stack(
              fit: StackFit.expand,
              children: [
                _isInitialized
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: Video(
                          fill: Colors.black,
                          controls: (state) => Container(),
                          controller: _controller,
                          filterQuality: FilterQuality.none,
                          fit: BoxFit.contain,
                          width: screenSize.width,
                          height: screenSize.width * ConfigCustom.fixHeight / ConfigCustom.fixWidth,
                        ),
                      )
                    : circularProgessCustom(),
                const JackpotDisplay(), // Renamed from JackpotDisplay for clarity
              ],
            ),
          ),
        );
      },
    );
  }
}
