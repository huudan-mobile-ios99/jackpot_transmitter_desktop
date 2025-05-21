import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Settings {
  final String endpointWebSocket;
  final String endpointJpHit;
  final String videoBackgroundScreen1;
  final String videoBackgroundScreen2;
  final int durationFadeAnimateScreenSwitchMs;
  final int durationFadeAnimateHitJpMs;
  final int durationShowVideoBackgroundSecond;
  final int durationShowVideoBackgroundJackpotSecond;
  final int durationShowVideoBackgroundHotseatSecond;
  final double windowWidth;
  final double windowHeight;
  final double windowMinWidth;
  final double windowMinHeight;
  final double windowBorderRadius;
  final String fontFamily;
  final double textHitPriceOffsetDx;
  final double textHitPriceOffsetDy;
  final double textHitPriceBlurRadius;
  final double textHitPriceSize;
  final double textHitPriceDX;
  final double textHitPriceDY;
  final double textHitNumberOffsetDx;
  final double textHitNumberOffsetDy;
  final double textHitNumberBlurRadius;
  final double textHitNumberSize;
  final double textHitNumberDX;
  final double textHitNumberDY;
  final double textOdoSize;
  final double textOdoOffsetDx;
  final double textOdoBlurRadius;
  final double textOdoLetterWidth;
  final double textOdoLetterVerticalOffset;
  final double odoWidth;
  final double odoHeight;
  final double odoPositionTop;
  final String textOdoComment;
  final double jpFrequentScreen1DX;
  final double jpFrequentScreen1DY;
  final double jpDailyScreen1DX;
  final double jpDailyScreen1DY;
  final double jpDailygoldenScreen1DX;
  final double jpDailygoldenScreen1DY;
  final double jpDozenScreen1DX;
  final double jpDozenScreen1DY;
  final double jpWeeklyScreen1DX;
  final double jpWeeklyScreen1DY;
  final double jpHighlimitScreen2DX;
  final double jpHighlimitScreen2DY;
  final double jpDozenScreen2DX;
  final double jpDozenScreen2DY;
  final double jpTrippleScreen2DX;
  final double jpTrippleScreen2DY;
  final double jpWeeklyScreen2DX;
  final double jpWeeklyScreen2DY;
  final double jpMonthlyScreen2DX;
  final double jpMonthlyScreen2DY;
  final double jpVegasScreen1DX;
  final double jpVegasScreen2DY;
  final String jpScreenComment;
  final int jpIdFrequent;
  final String jpIdFrequentVideoPath;
  final int jpIdDaily;
  final String jpIdDailyVideoPath;
  final int jpIdDailygolden;
  final String jpIdDailygoldenVideoPath;
  final int jpIdDozen;
  final String jpIdDozenVideoPath;
  final int jpIdWeekly;
  final String jpIdWeeklyVideoPath;
  final int jpIdHighlimit;
  final String jpIdHighlimitVideoPath;
  final int jpIdMonthly;
  final String jpIdMonthlyVideoPath;
  final int jpIdVegas;
  final String jpIdVegasVideoPath;
  final int hotseatId7771st;
  final String jpId7771stVideoPath;
  final int hotseatId7772nd;
  final String jpId7772ndVideoPath;
  final int hotseatId10001st;
  final String jpId10001stVideoPath;
  final int hotseatId10002nd;
  final String jpId10002ndVideoPath;
  final int hotseatIdPpochiMonFri;
  final String jpIdPpochiMonFriVideoPath;
  final int hotseatIdPpochiSatSun;
  final String jpIdPpochiSatSunVideoPath;
  final int hotseatIdRLPpochi;
  final String jpIdRLPpochiVideoPath;
  final int hotseatIdNew20Ppochi;
  final String jpIdNew20PpochiVideoPath;

  Settings({
    required this.endpointWebSocket,
    required this.endpointJpHit,
    required this.videoBackgroundScreen1,
    required this.videoBackgroundScreen2,
    required this.durationFadeAnimateScreenSwitchMs,
    required this.durationFadeAnimateHitJpMs,
    required this.durationShowVideoBackgroundSecond,
    required this.durationShowVideoBackgroundJackpotSecond,
    required this.durationShowVideoBackgroundHotseatSecond,
    required this.windowWidth,
    required this.windowHeight,
    required this.windowMinWidth,
    required this.windowMinHeight,
    required this.windowBorderRadius,
    required this.fontFamily,
    required this.textHitPriceOffsetDx,
    required this.textHitPriceOffsetDy,
    required this.textHitPriceBlurRadius,
    required this.textHitPriceSize,
    required this.textHitPriceDX,
    required this.textHitPriceDY,
    required this.textHitNumberOffsetDx,
    required this.textHitNumberOffsetDy,
    required this.textHitNumberBlurRadius,
    required this.textHitNumberSize,
    required this.textHitNumberDX,
    required this.textHitNumberDY,
    required this.textOdoSize,
    required this.textOdoOffsetDx,
    required this.textOdoBlurRadius,
    required this.textOdoLetterWidth,
    required this.textOdoLetterVerticalOffset,
    required this.odoWidth,
    required this.odoHeight,
    required this.odoPositionTop,
    required this.textOdoComment,
    required this.jpFrequentScreen1DX,
    required this.jpFrequentScreen1DY,
    required this.jpDailyScreen1DX,
    required this.jpDailyScreen1DY,
    required this.jpDailygoldenScreen1DX,
    required this.jpDailygoldenScreen1DY,
    required this.jpDozenScreen1DX,
    required this.jpDozenScreen1DY,
    required this.jpWeeklyScreen1DX,
    required this.jpWeeklyScreen1DY,
    required this.jpHighlimitScreen2DX,
    required this.jpHighlimitScreen2DY,
    required this.jpDozenScreen2DX,
    required this.jpDozenScreen2DY,
    required this.jpTrippleScreen2DX,
    required this.jpTrippleScreen2DY,
    required this.jpWeeklyScreen2DX,
    required this.jpWeeklyScreen2DY,
    required this.jpMonthlyScreen2DX,
    required this.jpMonthlyScreen2DY,
    required this.jpVegasScreen1DX,
    required this.jpVegasScreen2DY,
    required this.jpScreenComment,
    required this.jpIdFrequent,
    required this.jpIdFrequentVideoPath,
    required this.jpIdDaily,
    required this.jpIdDailyVideoPath,
    required this.jpIdDailygolden,
    required this.jpIdDailygoldenVideoPath,
    required this.jpIdDozen,
    required this.jpIdDozenVideoPath,
    required this.jpIdWeekly,
    required this.jpIdWeeklyVideoPath,
    required this.jpIdHighlimit,
    required this.jpIdHighlimitVideoPath,
    required this.jpIdMonthly,
    required this.jpIdMonthlyVideoPath,
    required this.jpIdVegas,
    required this.jpIdVegasVideoPath,
    required this.hotseatId7771st,
    required this.jpId7771stVideoPath,
    required this.hotseatId7772nd,
    required this.jpId7772ndVideoPath,
    required this.hotseatId10001st,
    required this.jpId10001stVideoPath,
    required this.hotseatId10002nd,
    required this.jpId10002ndVideoPath,
    required this.hotseatIdPpochiMonFri,
    required this.jpIdPpochiMonFriVideoPath,
    required this.hotseatIdPpochiSatSun,
    required this.jpIdPpochiSatSunVideoPath,
    required this.hotseatIdRLPpochi,
    required this.jpIdRLPpochiVideoPath,
    required this.hotseatIdNew20Ppochi,
    required this.jpIdNew20PpochiVideoPath,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      endpointWebSocket: json['endpoint_web_socket'] ?? 'ws://192.168.100.165:8080',
      endpointJpHit: json['endpoint_jp_hit'] ?? 'http://192.168.101.58:8097',
      videoBackgroundScreen1: json['video_background_screen1'] ?? 'asset/video/video_background.mp4',
      videoBackgroundScreen2: json['video_background_screen2'] ?? 'asset/video/video_background2.mp4',
      durationFadeAnimateScreenSwitchMs: json['duration_fade_animate_screen_switch_ms'] ?? 500,
      durationFadeAnimateHitJpMs: json['duration_fade_animate_hit_jp_ms'] ?? 600,
      durationShowVideoBackgroundSecond: json['duration_show_video_background_second'] ?? 30,
      durationShowVideoBackgroundJackpotSecond: json['duration_show_video_background_jackpot_second'] ?? 30,
      durationShowVideoBackgroundHotseatSecond: json['duration_show_video_background_hotseat_second'] ?? 30,
      windowWidth: (json['window_width'] ?? 1536).toDouble(),
      windowHeight: (json['width_height'] ?? 864).toDouble(),
      windowMinWidth: (json['window_min_width'] ?? 1536).toDouble(),
      windowMinHeight: (json['width_min_height'] ?? 864).toDouble(),
      windowBorderRadius: (json['window_border_radius'] ?? 16).toDouble(),
      fontFamily: json['font_family'] ?? 'sf-pro-display',
      textHitPriceOffsetDx: (json['text_hit_price_offset_dx'] ?? 0).toDouble(),
      textHitPriceOffsetDy: (json['text_hit_price_offset_dy'] ?? 3).toDouble(),
      textHitPriceBlurRadius: (json['text_hit_price_blur_radius'] ?? 4).toDouble(),
      textHitPriceSize: (json['text_hit_price_size'] ?? 55).toDouble(),
      textHitPriceDX: (json['text_hit_price_dX'] ?? 100).toDouble(),
      textHitPriceDY: (json['text_hit_price_dY'] ?? 100).toDouble(),
      textHitNumberOffsetDx: (json['text_hit_number_offset_dx'] ?? 0).toDouble(),
      textHitNumberOffsetDy: (json['text_hit_number_offset_dy'] ?? 2).toDouble(),
      textHitNumberBlurRadius: (json['text_hit_number_blur_radius'] ?? 4).toDouble(),
      textHitNumberSize: (json['text_hit_number_size'] ?? 145).toDouble(),
      textHitNumberDX: (json['text_hit_number_dX'] ?? 100).toDouble(),
      textHitNumberDY: (json['text_hit_number_dY'] ?? 100).toDouble(),
      textOdoSize: (json['text_odo_size'] ?? 100).toDouble(),
      textOdoOffsetDx: (json['text_odo_offset_dx'] ?? 0).toDouble(),
      textOdoBlurRadius: (json['text_odo_blur_radius'] ?? 3.5).toDouble(),
      textOdoLetterWidth: (json['text_odo_letter_width'] ?? 61.5).toDouble(),
      textOdoLetterVerticalOffset: (json['text_odo_letter_vertical_offset'] ?? 110).toDouble(),
      odoWidth: (json['odo_width'] ?? 768).toDouble(),
      odoHeight: (json['odo_height'] ?? 107.5).toDouble(),
      odoPositionTop: (json['odo_position_top'] ?? -19.5).toDouble(),
      textOdoComment: json['text_odo_comment'] ?? 'odo_width=width/2 (current:1536/2);text odo_letter_width = text_odo_size*0.615; text_odo_letter_vertical_offset =text_odo_size* 1.1',
      jpFrequentScreen1DX: (json['jp_frequent_screen1_dX'] ?? 1).toDouble(),
      jpFrequentScreen1DY: (json['jp_frequent_screen1_dY'] ?? 1).toDouble(),
      jpDailyScreen1DX: (json['jp_daily_screen1_dX'] ?? 1).toDouble(),
      jpDailyScreen1DY: (json['jp_daily_screen1_dY'] ?? 1).toDouble(),
      jpDailygoldenScreen1DX: (json['jp_dailygolden_screen1_dX'] ?? 1).toDouble(),
      jpDailygoldenScreen1DY: (json['jp_dailygolden_screen1_dY'] ?? 1).toDouble(),
      jpDozenScreen1DX: (json['jp_dozen_screen1_dX'] ?? 1).toDouble(),
      jpDozenScreen1DY: (json['jp_dozen_screen1_dY'] ?? 1).toDouble(),
      jpWeeklyScreen1DX: (json['jp_weekly_screen1_dX'] ?? 1).toDouble(),
      jpWeeklyScreen1DY: (json['jp_weekly_screen1_dY'] ?? 1).toDouble(),
      jpHighlimitScreen2DX: (json['jp_highlimit_screen2_dX'] ?? 1).toDouble(),
      jpHighlimitScreen2DY: (json['jp_highlimit_screen2_dY'] ?? 1).toDouble(),
      jpDozenScreen2DX: (json['jp_dozen_screen2_dX'] ?? 1).toDouble(),
      jpDozenScreen2DY: (json['jp_dozen_screen2_dY'] ?? 1).toDouble(),
      jpTrippleScreen2DX: (json['jp_tripple_screen2_dX'] ?? 1).toDouble(),
      jpTrippleScreen2DY: (json['jp_tripple_screen2_dY'] ?? 1).toDouble(),
      jpWeeklyScreen2DX: (json['jp_weekly_screen2_dX'] ?? 1).toDouble(),
      jpWeeklyScreen2DY: (json['jp_weekly_screen2_dY'] ?? 1).toDouble(),
      jpMonthlyScreen2DX: (json['jp_monthly_screen2_dX'] ?? 1).toDouble(),
      jpMonthlyScreen2DY: (json['jp_monthly_screen2_dY'] ?? 1).toDouble(),
      jpVegasScreen1DX: (json['jp_vegas_screen1_dX'] ?? 1).toDouble(),
      jpVegasScreen2DY: (json['jp_vegas_screen2_dY'] ?? 1).toDouble(),
      jpScreenComment: json['jp_screen_comment'] ?? 'jp_screen1 for layout 1 content 5 prices jackpot, jp_screen2 for layout 2 content 6 price jackpot',
      jpIdFrequent: json['jp_id_frequent'] ?? 0,
      jpIdFrequentVideoPath: json['jp_id_frequent_video_path'] ?? 'asset/video/frequent.mpg',
      jpIdDaily: json['jp_id_daily'] ?? 1,
      jpIdDailyVideoPath: json['jp_id_daily_video_path'] ?? 'asset/video/daily.mpg',
      jpIdDailygolden: json['jp_id_dailygolden'] ?? 34,
      jpIdDailygoldenVideoPath: json['jp_id_dailygolden_video_path'] ?? 'asset/video/daily_golden.mpg',
      jpIdDozen: json['jp_id_dozen'] ?? 2,
      jpIdDozenVideoPath: json['jp_id_dozen_video_path'] ?? 'asset/video/dozen.mpg',
      jpIdWeekly: json['jp_id_weekly'] ?? 3,
      jpIdWeeklyVideoPath: json['jp_id_weekly_video_path'] ?? 'asset/video/weekly.mpg',
      jpIdHighlimit: json['jp_id_highlimit'] ?? 45,
      jpIdHighlimitVideoPath: json['jp_id_highlimit_video_path'] ?? 'asset/video/high_limit.mpg',
      jpIdMonthly: json['jp_id_monthly'] ?? 46,
      jpIdMonthlyVideoPath: json['jp_id_monthly_video_path'] ?? 'asset/video/vegas.mpg',
      jpIdVegas: json['jp_id_vegas'] ?? 4,
      jpIdVegasVideoPath: json['jp_id_vegas_video_path'] ?? 'asset/video/vegas.mpg',
      hotseatId7771st: json['hotseat_id_777_1st'] ?? 80,
      jpId7771stVideoPath: json['jp_id_777_1st_video_path'] ?? 'asset/video/ppochi.mpg',
      hotseatId7772nd: json['hotseat_id_777_2nd'] ?? 81,
      jpId7772ndVideoPath: json['jp_id_777_2nd_video_path'] ?? 'asset/video/ppochi.mpg',
      hotseatId10001st: json['hotseat_id_1000_1st'] ?? 88,
      jpId10001stVideoPath: json['jp_id_1000_1st_video_path'] ?? 'asset/video/ppochi.mpg',
      hotseatId10002nd: json['hotseat_id_1000_2nd'] ?? 89,
      jpId10002ndVideoPath: json['jp_id_1000_2nd_video_path'] ?? 'asset/video/ppochi.mpg',
      hotseatIdPpochiMonFri: json['hotseat_id_ppochi_Mon_Fri'] ?? 97,
      jpIdPpochiMonFriVideoPath: json['jp_id_ppochi_Mon_Fri_video_path'] ?? 'asset/video/ppochi.mpg',
      hotseatIdPpochiSatSun: json['hotseat_id_ppochi_Sat_Sun'] ?? 98,
      jpIdPpochiSatSunVideoPath: json['jp_id_ppochi_Sat_Sun_video_path'] ?? 'asset/video/ppochi.mpg',
      hotseatIdRLPpochi: json['hotseat_id_RL_ppochi'] ?? 109,
      jpIdRLPpochiVideoPath: json['jp_id_RL_ppochi_video_path'] ?? 'asset/video/ppochi.mpg',
      hotseatIdNew20Ppochi: json['hotseat_id_New_20_ppochi'] ?? 119,
      jpIdNew20PpochiVideoPath: json['jp_id_New_20_ppochi_video_path'] ?? 'asset/video/ppochi.mpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endpoint_web_socket': endpointWebSocket,
      'endpoint_jp_hit': endpointJpHit,
      'video_background_screen1': videoBackgroundScreen1,
      'video_background_screen2': videoBackgroundScreen2,
      'duration_fade_animate_screen_switch_ms': durationFadeAnimateScreenSwitchMs,
      'duration_fade_animate_hit_jp_ms': durationFadeAnimateHitJpMs,
      'duration_show_video_background_second': durationShowVideoBackgroundSecond,
      'duration_show_video_background_jackpot_second': durationShowVideoBackgroundJackpotSecond,
      'duration_show_video_background_hotseat_second': durationShowVideoBackgroundHotseatSecond,
      'window_width': windowWidth,
      'width_height': windowHeight,
      'window_min_width': windowMinWidth,
      'width_min_height': windowMinHeight,
      'window_border_radius': windowBorderRadius,
      'font_family': fontFamily,
      'text_hit_price_offset_dx': textHitPriceOffsetDx,
      'text_hit_price_offset_dy': textHitPriceOffsetDy,
      'text_hit_price_blur_radius': textHitPriceBlurRadius,
      'text_hit_price_size': textHitPriceSize,
      'text_hit_price_dX': textHitPriceDX,
      'text_hit_price_dY': textHitPriceDY,
      'text_hit_number_offset_dx': textHitNumberOffsetDx,
      'text_hit_number_offset_dy': textHitNumberOffsetDy,
      'text_hit_number_blur_radius': textHitNumberBlurRadius,
      'text_hit_number_size': textHitNumberSize,
      'text_hit_number_dX': textHitNumberDX,
      'text_hit_number_dY': textHitNumberDY,
      'text_odo_size': textOdoSize,
      'text_odo_offset_dx': textOdoOffsetDx,
      'text_odo_blur_radius': textOdoBlurRadius,
      'text_odo_letter_width': textOdoLetterWidth,
      'text_odo_letter_vertical_offset': textOdoLetterVerticalOffset,
      'odo_width': odoWidth,
      'odo_height': odoHeight,
      'odo_position_top': odoPositionTop,
      'text_odo_comment': textOdoComment,
      'jp_frequent_screen1_dX': jpFrequentScreen1DX,
      'jp_frequent_screen1_dY': jpFrequentScreen1DY,
      'jp_daily_screen1_dX': jpDailyScreen1DX,
      'jp_daily_screen1_dY': jpDailyScreen1DY,
      'jp_dailygolden_screen1_dX': jpDailygoldenScreen1DX,
      'jp_dailygolden_screen1_dY': jpDailygoldenScreen1DY,
      'jp_dozen_screen1_dX': jpDozenScreen1DX,
      'jp_dozen_screen1_dY': jpDozenScreen1DY,
      'jp_weekly_screen1_dX': jpWeeklyScreen1DX,
      'jp_weekly_screen1_dY': jpWeeklyScreen1DY,
      'jp_highlimit_screen2_dX': jpHighlimitScreen2DX,
      'jp_highlimit_screen2_dY': jpHighlimitScreen2DY,
      'jp_dozen_screen2_dX': jpDozenScreen2DX,
      'jp_dozen_screen2_dY': jpDozenScreen2DY,
      'jp_tripple_screen2_dX': jpTrippleScreen2DX,
      'jp_tripple_screen2_dY': jpTrippleScreen2DY,
      'jp_weekly_screen2_dX': jpWeeklyScreen2DX,
      'jp_weekly_screen2_dY': jpWeeklyScreen2DY,
      'jp_monthly_screen2_dX': jpMonthlyScreen2DX,
      'jp_monthly_screen2_dY': jpMonthlyScreen2DY,
      'jp_vegas_screen1_dX': jpVegasScreen1DX,
      'jp_vegas_screen2_dY': jpVegasScreen2DY,
      'jp_screen_comment': jpScreenComment,
      'jp_id_frequent': jpIdFrequent,
      'jp_id_frequent_video_path': jpIdFrequentVideoPath,
      'jp_id_daily': jpIdDaily,
      'jp_id_daily_video_path': jpIdDailyVideoPath,
      'jp_id_dailygolden': jpIdDailygolden,
      'jp_id_dailygolden_video_path': jpIdDailygoldenVideoPath,
      'jp_id_dozen': jpIdDozen,
      'jp_id_dozen_video_path': jpIdDozenVideoPath,
      'jp_id_weekly': jpIdWeekly,
      'jp_id_weekly_video_path': jpIdWeeklyVideoPath,
      'jp_id_highlimit': jpIdHighlimit,
      'jp_id_highlimit_video_path': jpIdHighlimitVideoPath,
      'jp_id_monthly': jpIdMonthly,
      'jp_id_monthly_video_path': jpIdMonthlyVideoPath,
      'jp_id_vegas': jpIdVegas,
      'jp_id_vegas_video_path': jpIdVegasVideoPath,
      'hotseat_id_777_1st': hotseatId7771st,
      'jp_id_777_1st_video_path': jpId7771stVideoPath,
      'hotseat_id_777_2nd': hotseatId7772nd,
      'jp_id_777_2nd_video_path': jpId7772ndVideoPath,
      'hotseat_id_1000_1st': hotseatId10001st,
      'jp_id_1000_1st_video_path': jpId10001stVideoPath,
      'hotseat_id_1000_2nd': hotseatId10002nd,
      'jp_id_1000_2nd_video_path': jpId10002ndVideoPath,
      'hotseat_id_ppochi_Mon_Fri': hotseatIdPpochiMonFri,
      'jp_id_ppochi_Mon_Fri_video_path': jpIdPpochiMonFriVideoPath,
      'hotseat_id_ppochi_Sat_Sun': hotseatIdPpochiSatSun,
      'jp_id_ppochi_Sat_Sun_video_path': jpIdPpochiSatSunVideoPath,
      'hotseat_id_RL_ppochi': hotseatIdRLPpochi,
      'jp_id_RL_ppochi_video_path': jpIdRLPpochiVideoPath,
      'hotseat_id_New_20_ppochi': hotseatIdNew20Ppochi,
      'jp_id_New_20_ppochi_video_path': jpIdNew20PpochiVideoPath,
    };
  }
}

class SettingsService {
  Future<Settings> loadSettings() async {
    try {
      final jsonString = await rootBundle.loadString('assets/settings.json');
      final jsonMap = jsonDecode(jsonString);
      return Settings.fromJson(jsonMap);
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Return default settings if loading fails
      return Settings(
        endpointWebSocket: 'ws://192.168.100.165:8080',
        endpointJpHit: 'http://192.168.101.58:8097',
        videoBackgroundScreen1: 'asset/video/video_background.mp4',
        videoBackgroundScreen2: 'asset/video/video_background2.mp4',
        durationFadeAnimateScreenSwitchMs: 500,
        durationFadeAnimateHitJpMs: 600,
        durationShowVideoBackgroundSecond: 30,
        durationShowVideoBackgroundJackpotSecond: 30,
        durationShowVideoBackgroundHotseatSecond: 30,
        windowWidth: 1536,
        windowHeight: 864,
        windowMinWidth: 1536,
        windowMinHeight: 864,
        windowBorderRadius: 16,
        fontFamily: 'sf-pro-display',
        textHitPriceOffsetDx: 0,
        textHitPriceOffsetDy: 3,
        textHitPriceBlurRadius: 4,
        textHitPriceSize: 55,
        textHitPriceDX: 100,
        textHitPriceDY: 100,
        textHitNumberOffsetDx: 0,
        textHitNumberOffsetDy: 2,
        textHitNumberBlurRadius: 4,
        textHitNumberSize: 145,
        textHitNumberDX: 100,
        textHitNumberDY: 100,
        textOdoSize: 100,
        textOdoOffsetDx: 0,
        textOdoBlurRadius: 3.5,
        textOdoLetterWidth: 61.5,
        textOdoLetterVerticalOffset: 110,
        odoWidth: 768,
        odoHeight: 107.5,
        odoPositionTop: -19.5,
        textOdoComment: 'odo_width=width/2 (current:1536/2);text odo_letter_width = text_odo_size*0.615; text_odo_letter_vertical_offset =text_odo_size* 1.1',
        jpFrequentScreen1DX: 1,
        jpFrequentScreen1DY: 1,
        jpDailyScreen1DX: 1,
        jpDailyScreen1DY: 1,
        jpDailygoldenScreen1DX: 1,
        jpDailygoldenScreen1DY: 1,
        jpDozenScreen1DX: 1,
        jpDozenScreen1DY: 1,
        jpWeeklyScreen1DX: 1,
        jpWeeklyScreen1DY: 1,
        jpHighlimitScreen2DX: 1,
        jpHighlimitScreen2DY: 1,
        jpDozenScreen2DX: 1,
        jpDozenScreen2DY: 1,
        jpTrippleScreen2DX: 1,
        jpTrippleScreen2DY: 1,
        jpWeeklyScreen2DX: 1,
        jpWeeklyScreen2DY: 1,
        jpMonthlyScreen2DX: 1,
        jpMonthlyScreen2DY: 1,
        jpVegasScreen1DX: 1,
        jpVegasScreen2DY: 1,
        jpScreenComment: 'jp_screen1 for layout 1 content 5 prices jackpot, jp_screen2 for layout 2 content 6 price jackpot',
        
        jpIdFrequent: 0,
        jpIdFrequentVideoPath: 'asset/video/frequent.mpg',
        jpIdDaily: 1,
        jpIdDailyVideoPath: 'asset/video/daily.mpg',
        jpIdDailygolden: 34,
        jpIdDailygoldenVideoPath: 'asset/video/daily_golden.mpg',
        jpIdDozen: 2,
        jpIdDozenVideoPath: 'asset/video/dozen.mpg',
        jpIdWeekly: 3,
        jpIdWeeklyVideoPath: 'asset/video/weekly.mpg',
        jpIdHighlimit: 45,
        jpIdHighlimitVideoPath: 'asset/video/high_limit.mpg',
        jpIdMonthly: 46,
        jpIdMonthlyVideoPath: 'asset/video/vegas.mpg',
        jpIdVegas: 4,
        jpIdVegasVideoPath: 'asset/video/vegas.mpg',
        hotseatId7771st: 80,
        jpId7771stVideoPath: 'asset/video/ppochi.mpg',
        hotseatId7772nd: 81,
        jpId7772ndVideoPath: 'asset/video/ppochi.mpg',
        hotseatId10001st: 88,
        jpId10001stVideoPath: 'asset/video/ppochi.mpg',
        hotseatId10002nd: 89,
        jpId10002ndVideoPath: 'asset/video/ppochi.mpg',
        hotseatIdPpochiMonFri: 97,
        jpIdPpochiMonFriVideoPath: 'asset/video/ppochi.mpg',
        hotseatIdPpochiSatSun: 98,
        jpIdPpochiSatSunVideoPath: 'asset/video/ppochi.mpg',
        hotseatIdRLPpochi: 109,
        jpIdRLPpochiVideoPath: 'asset/video/ppochi.mpg',
        hotseatIdNew20Ppochi: 119,
        jpIdNew20PpochiVideoPath: 'asset/video/ppochi.mpg',
      );
    }
  }
}
