import 'dart:async';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';
import 'package:playtech_transmitter_app/widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.setWindowBackgroundColorToClear();
  await Window.makeTitlebarTransparent();
  await Window.addEmptyMaskImage();
  await Window.disableShadow();
  await Window.hideTitle();
  await Window.hideWindowControls();
  runApp(MyApp());
  doWhenWindowReady(() {
      appWindow
        ..minSize = Size(320, 130)
        ..size = Size(560, 360)
        ..alignment = Alignment.center
        ..show();
    });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent
      ),
      home: MyAppBody(),
    );
  }
}
enum InterfaceBrightness {
  light,
  dark,
  auto,
}
extension InterfaceBrightnessExtension on InterfaceBrightness {
  bool getIsDark(BuildContext? context) {
    if (this == InterfaceBrightness.light) return false;
    if (this == InterfaceBrightness.auto) {
      if (context == null) return true;
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return true;
  }
  Color getForegroundColor(BuildContext? context) {
    return getIsDark(context) ? Colors.white : Colors.black;
  }
}

class MyAppBody extends StatefulWidget {
  MyAppBody({Key? key}) : super(key: key);

  @override
  MyAppBodyState createState() => MyAppBodyState();
}

class MyAppBodyState extends State<MyAppBody> {
  WindowEffect effect = WindowEffect.transparent;
  @override
  void initState() {
    super.initState();
    this.setWindowEffect(WindowEffect.aero);
  }

  void setWindowEffect(WindowEffect? value) {
    Window.setEffect(
      effect: value!,
      color: Colors.transparent,
      dark: false,
    );
    this.setState(() => this.effect = value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Text(
            "14,000\$",
            style: TextStyle(
              fontSize: 72.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ],
),
    );
  }
}

