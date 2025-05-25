import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/widget/circlar_progress_custom.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_page.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class JackpotBackgroundShowWindowFadeAnimateV1 extends StatefulWidget {
  const JackpotBackgroundShowWindowFadeAnimateV1({super.key});

  @override
  _JackpotBackgroundShowWindowFadeAnimateV1State createState() => _JackpotBackgroundShowWindowFadeAnimateV1State();
}

class _JackpotBackgroundShowWindowFadeAnimateV1State extends State<JackpotBackgroundShowWindowFadeAnimateV1>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  Player? _player;
  VideoController? _controller;
  bool _isInitialized = false;
  String? _currentVideoPath;
  DateTime? _lastSwitchTime;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // debugPrint('Initializing MediaKit');
    MediaKit.ensureInitialized();
    // Initialize fade animation for transitions
    _fadeController = AnimationController(
      duration:  Duration(milliseconds: ConfigCustom.switchBetweeScreenDuration),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Initialize first video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // debugPrint('Initializing first video: ${ConfigCustom.videoBg}');
      _initializePlayer(ConfigCustom.videoBg, DateTime.now());
    });
  }

  Future<void> _initializePlayer(String videoPath, DateTime switchTime) async {
    if (_currentVideoPath == videoPath) {
      // debugPrint('Video unchanged: $videoPath, skipping initialization');
      return;
    }

    // debugPrint('Initializing player for: $videoPath');
    // Dispose of existing player
    await _player?.dispose();
    setState(() {
      _isInitialized = false;
      _controller = null;
    });

    // Create new player and controller
    _player = Player();
    _controller = VideoController(
      _player!,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    try {
      _currentVideoPath = videoPath;
      _lastSwitchTime = switchTime;
      // debugPrint('Opening media: asset:///$videoPath');
      await _player!.open(Media('asset:///$videoPath'), play: false);
      // debugPrint('Setting playlist mode and volume');
      await _player!.setPlaylistMode(PlaylistMode.loop);
      await _player!.setVolume(0.0);
      // debugPrint('Playing video');
      await _player!.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          // debugPrint('Video initialized successfully');
        });
        // Trigger fade-in transition
        _fadeController.reset();
        await _fadeController.forward();
        // debugPrint('Fade-in complete');
      }
    } catch (error) {
      // debugPrint('Error initializing video: $error');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
          _lastSwitchTime = null;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // debugPrint('Lifecycle state changed: $state');
    super.didChangeAppLifecycleState(state);
    if (_player != null && _isInitialized) {
      if (state == AppLifecycleState.resumed && !_player!.state.playing) {
        // debugPrint('Resuming playback');
        _player!.play();
      } else if (state != AppLifecycleState.resumed && _player!.state.playing) {
        // debugPrint('Pausing playback');
        _player!.pause();
      }
    }
  }

  @override
  void dispose() {
    // debugPrint('Disposing widget');
    WidgetsBinding.instance.removeObserver(this);
    _player?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, ViddeoState>(
      builder: (context, state) {
        // debugPrint('BlocBuilder state: id=${state.id}, video=${state.currentVideo}');
        // Trigger video switch if video or switch time changes
        if (_currentVideoPath != state.currentVideo || _lastSwitchTime != state.lastSwitchTime) {
          _initializePlayer(state.currentVideo, state.lastSwitchTime);
        }
        return Stack(
          children: [
            SizedBox(
              width: ConfigCustom.fixWidth,
              height: ConfigCustom.fixHeight,
              child: (_isInitialized && _controller != null)?
                AspectRatio(
                  aspectRatio: ConfigCustom.fixWidth / ConfigCustom.fixHeight,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Video(
                      fill: Colors.black,
                      // fill: Colors.transparent,
                      controls: (state) {
                        return Container();
                      },
                      controller: _controller!,
                      filterQuality: FilterQuality.none,
                      fit: BoxFit.contain,
                    ),
                  ),)
              : circularProgessCustom(),
            ),
             JackpotDisplay(),
          ],
        );
      },
    );
  }
}
