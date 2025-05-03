import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';
import 'package:playtech_transmitter_app/jackpot_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.setWindowBackgroundColorToClear();
  await Window.makeTitlebarTransparent();
  await Window.addEmptyMaskImage();
  await Window.disableShadow();
  // await Window.hideTitle();
  await Window.hideWindowControls();
  runApp(const MyApp());
  doWhenWindowReady(() {
      appWindow
        ..minSize = Size(1250, 625)
        ..size = Size(1375, 825)
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
    setWindowEffect(WindowEffect.aero);
  }

  void setWindowEffect(WindowEffect? value) {
    Window.setEffect(
      effect: value!,
      color: Colors.transparent,
      dark: false,
    );
    setState(() => effect = value);
  }


  @override
  Widget build(BuildContext context) {
    return JackpotDisplay();
  }
}


