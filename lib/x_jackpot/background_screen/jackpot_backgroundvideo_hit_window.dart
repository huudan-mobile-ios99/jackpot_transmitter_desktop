import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:media_kit/media_kit.dart';                      // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';

class JackpotBackgroundVideoHitWindow extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHitWindow({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHitWindowState createState() => _JackpotBackgroundVideoHitWindowState();
}

class _JackpotBackgroundVideoHitWindowState extends State<JackpotBackgroundVideoHitWindow> with SingleTickerProviderStateMixin {
  late final player = Player();
  late final controller = VideoController(player,
    configuration: const VideoControllerConfiguration(
    enableHardwareAcceleration: true,      // default: true
  ),
  );
  final numberFormat = NumberFormat('#,##0.00', 'en_US');
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final double fontSize= 145;

  // Map id to video asset paths
  String getVideoAssetPath(String id) {
    debugPrint('getVideoAssetPath ${id}');
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
    // player.open(Media('asset:///asset/video/frequent.mpg'));
     player.open(Media('asset:///${getVideoAssetPath(widget.id)}'));
     player.setPlaylistMode(PlaylistMode.loop);
     player.setVolume(100.0);
    // Initialize the video controller with the selected asset based on id
  }

  @override
  void dispose() {
    // Dispose of the video controller to free resources
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final  textStyle =  TextStyle(
      fontSize: fontSize,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 4),
          blurRadius: 8,
        ),
      ],
    );
     const textStyleSmall =  TextStyle(
      fontSize: 55,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.normal,
      shadows: [
        Shadow(
          color: Colors.orangeAccent,
          offset: Offset(0, 3),
          blurRadius: 6,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0), // Rounded corners
                    child:AspectRatio(
                      aspectRatio: ConfigCustom.fixWidth/ConfigCustom.fixHeight,
                      child: Video(controller: controller,filterQuality: FilterQuality.high,fit: BoxFit.cover,),
                    ),
                  )
              ],
            ),
          ),
          // Horizontally centered text with manual vertical offset
          Positioned(
            left: 0,
            right: 0,
            top: ConfigCustom.fixHeight / 2-fontSize,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '\$${numberFormat.format(num.parse(widget.value))}',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 26,
            right: 86,
            child: Text('#${widget.number}', style: textStyleSmall),
          ),
        ],
      ),
    );
  }
}
