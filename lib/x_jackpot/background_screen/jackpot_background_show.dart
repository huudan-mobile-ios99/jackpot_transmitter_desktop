import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/widget/circlar_progress_custom.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_page.dart';
import 'package:video_player/video_player.dart';

class JackpotBackgroundShow extends StatefulWidget {
  const JackpotBackgroundShow({super.key});

  @override
  _JackpotBackgroundShowState createState() => _JackpotBackgroundShowState();
}

class _JackpotBackgroundShowState extends State< JackpotBackgroundShow>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideoController(ConfigCustom.videoBg);
  }

  void _initializeVideoController(String videoPath) {
    _controller?.dispose(); // Dispose of any existing controller
    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller!.setVolume(0.0);
          _controller!.setLooping(true);
          _controller!.play();
        }
      }).catchError((error) {
        debugPrint('Error initializing video: $error');
        if (mounted) {
          setState(() {
            _isInitialized = false;
          });
        }
      });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_controller != null && _controller!.value.isInitialized) {
      if (state == AppLifecycleState.resumed) {
        _controller!.play();
      } else {
        _controller!.pause();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<VideoBloc, ViddeoState>(
        builder: (context, state) {
          // Reinitialize controller if the video changes
          if (_controller != null &&
              _controller!.value.isInitialized &&
              _controller!.dataSource != state.currentVideo) {
            _initializeVideoController(state.currentVideo);
          }

          return Center(
            child: Stack(
              children: [
                SizedBox(
                  width: ConfigCustom.fixWidth,
                  height: ConfigCustom.fixHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_isInitialized &&
                          _controller != null &&
                          _controller!.value.isInitialized)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                        )
                      else
                        circularProgessCustom(),
                    ],
                  ),
                ),
                // Uncomment if JackpotDisplay is needed
                const JackpotDisplay(),
                // Text('${state.currentVideo} ${state.id}',style:TextStyle(color:Colors.white))
              ],
            ),
          );
        },

    );
  }
}
