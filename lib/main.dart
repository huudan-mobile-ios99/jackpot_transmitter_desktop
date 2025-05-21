import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_background_show.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_background_show_window.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_background_show_window_fade_animation.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_screen.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc2/jackpot_bloc2.dart';
import 'package:media_kit/media_kit.dart';                      // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Window.initialize();
  // await Window.setWindowBackgroundColorToClear();
  await Window.makeTitlebarTransparent();
  // await Window.addEmptyMaskImage();
  // await Window.disableShadow();
  await Window.hideWindowControls();
  // await Window.hideTitle();
  runApp(const MyApp());
  doWhenWindowReady(() {
      appWindow
        // ..minSize =const Size(1920, 1080)
        // ..size =const Size(1920, 1080)
        ..size =const Size(ConfigCustom.fixWidth, ConfigCustom.fixHeight)
        // ..minSize =const Size(1536, 864)
        // ..minSize =const Size(960, 540)
        // ..size =const Size(960, 540)
        // ..minSize =const Size(1920, 1080)
        // ..size =const Size(1920, 1080)
        ..alignment = Alignment.center
        ..startDragging()
        ..show();
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent
      ),
      home: const MyAppBody(),
    );
  }
}

class MyAppBody extends StatefulWidget {
  const MyAppBody({super.key});
  @override
  MyAppBodyState createState() => MyAppBodyState();
}

class MyAppBodyState extends State<MyAppBody> {
  WindowEffect effect = WindowEffect.transparent;
  @override
  void initState() {
    super.initState();
    Window.setEffect(
      effect: WindowEffect.transparent,
      color: Colors.transparent,
      dark: false,
    );
  }



  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider( create: (context) => JackpotBloc2(),),
        BlocProvider(  create: (context) => VideoBloc(videoBg1: ConfigCustom.videoBg, videoBg2: ConfigCustom.videoBg2),
      ),
      ],
      child: const Scaffold(
        body:
         Stack(
          children: [
             JackpotBackgroundShowWindowFadeAnimate(), //show first (contain background and number jp prices)
             JackpotHitScreen(), //show second (contain video background of types of jp prices based on its id)
          ],
        )
      ),
    );
  }
}





































// // Make sure to add following packages to pubspec.yaml:
// // * media_kit
// // * media_kit_video
// // * media_kit_libs_video
// import 'package:flutter/material.dart';
// import 'package:media_kit/media_kit.dart';                      // Provides [Player], [Media], [Playlist] etc.
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:playtech_transmitter_app/config_custom.dart';          // Provides [VideoController] & [Video] etc.

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Necessary initialization for package:media_kit.
//   MediaKit.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyScreen(),
//     ),
//   );
// }

// class MyScreen extends StatefulWidget {
//   const MyScreen({Key? key}) : super(key: key);
//   @override
//   State<MyScreen> createState() => MyScreenState();
// }

// class MyScreenState extends State<MyScreen> {
//   late final player = Player();
//   late final controller = VideoController(player,
//     configuration: const VideoControllerConfiguration(
//     enableHardwareAcceleration: true,      // default: true
//   ),
//   );

//   // Map id to video asset paths
//   String getVideoAssetPath(String id) {
//     debugPrint('getVideoAssetPath ${id}');
//     switch (id) {
//       case '0':
//         return 'asset/video/frequent.mpg';
//       case '1':
//         return 'asset/video/daily.mpg';
//       case '2':
//         return 'asset/video/dozen.mpg';
//       case '3':
//         return 'asset/video/weekly.mpg';
//       case '4':
//         return 'asset/video/vegas.mpg';
//       case '18':
//         return 'asset/video/high_limit.mpg';
//       case '34':
//         return 'asset/video/daily_golden.mpg';
//       case '35':
//         return 'asset/video/tripple.mpg';
//       case '45':
//         return 'asset/video/high_limit.mpg';
//       case '46':
//         return 'asset/video/vegas.mpg';
//       case '44':
//         return 'asset/video/vegas.mpg';
//       case '80':
//         return 'asset/video/ppochi.mpg';
//       case '81':
//         return 'asset/video/ppochi.mpg';
//       case '88':
//         return 'asset/video/ppochi.mpg';
//       case '89':
//         return 'asset/video/ppochi.mpg';
//       case '97':
//         return 'asset/video/ppochi.mpg';
//       case '98':
//         return 'asset/video/ppochi_slot.mpg';
//       default:
//         return 'asset/video/frequent.mpg'; // Fallback to frequent if id is unknown
//     }
//   }

//   @override
//   void initState  ()  {
//     super.initState();
//     // Play a [Media] or [Playlist].
//      player.open(Media('asset:///${getVideoAssetPath('1')}'));
//      player.setPlaylistMode(PlaylistMode.loop);
//      player.setVolume(50.0);
//   }

//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         children: [
//           SizedBox(
//             width: ConfigCustom.fixWidth,
//             height: ConfigCustom.fixHeight,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(16.0), // Rounded corners
//                     child:AspectRatio(
//                       aspectRatio: 16/9,
//                       child: Video(controller: controller,filterQuality: FilterQuality.low,),
//                     ),
//                   )
//               ],
//             ),
//           ),
//           // Horizontally centered text with manual vertical offset
//           Positioned(
//             left: 0,
//             right: 0,
//             top: 540 / 2.935,
//             child: Container(
//               alignment: Alignment.center,
//               child: Text(
//                 '\234325}',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 12,
//             right: 36,
//             child: Text('#${123}', ),
//           ),
//         ],
//       ),
//     );
//   }
// }
