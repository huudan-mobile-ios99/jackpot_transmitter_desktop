

class ConfigCustom {
  // ignore: constant_identifier_names
  static const String urlSocketJPHit = 'http://192.168.101.58:8097';  // static const String urlSocketJPHit = 'http://30.0.0.56:3002';
  static const String endpointWebSocket= "ws://192.168.100.165:8080";  //endpointWebSocket= "ws://localhost:8080"
  static const double fixWidth= 1920; //1.25 ratio
  static const double fixHeight= 1080;//1.25 ratio

  static String videoBg = 'asset/video/video_background.mp4';
  static String videoBg2 = 'asset/video/video_background2.mp4';

  static int durationSwitchVideoSecond = 30;
  static int durationGetDataToBloc = 15;
  static int durationGetDataToBlocFirstMS = 50;
  static int switchBetweeScreenDuration = 500;
  static int switchBetweeScreenDurationForHitScreen = 600;
  static int durationTimerVideoHitShow = 30; //show video hit for 30

  static int secondToReConnect = 5;
}



// import 'package:flutter/material.dart';
// import 'settings_service.dart';

// class ConfigCustom {
//   static final SettingsService _settingsService = SettingsService();

//   static Future<void> init(BuildContext context) async {
//     await _settingsService.loadSettings(context);
//   }

//   static double get fixWidth => _settingsService.get<double>('window_width', defaultValue: 1536.0);
//   static double get fixHeight => _settingsService.get<double>('width_height', defaultValue: 864.0);
//   static int get switchBetweeScreenDuration => _settingsService.get<int>('duration_fade_animate_hit_jp_ms', defaultValue: 600);
//   static String get videoBg => _settingsService.get<String>('video_background_screen1', defaultValue: 'asset/video/video_background.mp4');
//   static String get videoBg2 => _settingsService.get<String>('video_background_screen2', defaultValue: 'asset/video/video_background2.mp4');
//   static int get durationShowVideoBackgroundJackpotSecond => _settingsService.get<int>('duration_show_video_background_jackpot_second', defaultValue: 30);
//   static String get fontFamily => _settingsService.get<String>('font_family', defaultValue: 'sf-pro-display');
// }
