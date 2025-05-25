import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/widget/circlar_progress_custom.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_page.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class JackpotBackgroundShowWindow extends StatefulWidget {
  const JackpotBackgroundShowWindow({super.key});

  @override
  _JackpotBackgroundShowWindowState createState() => _JackpotBackgroundShowWindowState();
}

class _JackpotBackgroundShowWindowState extends State<JackpotBackgroundShowWindow>
    with WidgetsBindingObserver {
  Player? _player;
  VideoController? _controller;
  bool _isInitialized = false;
  String? _currentVideoPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MediaKit.ensureInitialized();
    _initializePlayer(ConfigCustom.videoBg);
  }

  Future<void> _initializePlayer(String videoPath) async {
    if (_currentVideoPath == videoPath) {
      debugPrint('Video unchanged: $videoPath, skipping initialization');
      return;
    }

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
      await _player!.open(Media('asset:///$videoPath'), play: false);
      await _player!.setPlaylistMode(PlaylistMode.loop);
      await _player!.setVolume(0.0);
      await _player!.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (error) {
      debugPrint('Error initializing video: $error');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('Lifecycle state changed: $state');
    super.didChangeAppLifecycleState(state);
    if (_player != null) {
      if (state == AppLifecycleState.resumed) {
        _player!.play();
      } else {
        _player!.pause();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, ViddeoState>(
      builder: (context, state) {
        // Initialize new video when state changes
        _initializePlayer(state.currentVideo);

        return Center(
          child: Stack(
            children: [
              SizedBox(
                width: ConfigCustom.fixWidth,
                height: ConfigCustom.fixHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_isInitialized && _controller != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Video(
                          controller: _controller!,
                          filterQuality: FilterQuality.low,
                        ),
                      )
                    else circularProgessCustom(),
                  ],
                ),
              ),
               JackpotDisplay(),
              Text(
                '${state.currentVideo} ${state.id}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
