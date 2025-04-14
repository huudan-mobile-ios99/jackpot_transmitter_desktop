import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';
import 'package:playtech_transmitter_app/widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  if (Platform.isWindows) {
    await Window.hideWindowControls();
  }
  runApp(MyApp());
  doWhenWindowReady(() {
      appWindow
        ..minSize = Size(640, 360)
        ..size = Size(720, 540)
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
        splashFactory: InkRipple.splashFactory,
        scaffoldBackgroundColor: Colors.transparent
      ),
      darkTheme: ThemeData.dark().copyWith(
        splashFactory: InkRipple.splashFactory,
      ),
      themeMode: ThemeMode.dark,
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
  Color color = Platform.isWindows ? Color(0xCC222222) : Colors.transparent;
  InterfaceBrightness brightness =
      Platform.isMacOS ? InterfaceBrightness.auto : InterfaceBrightness.dark;
  MacOSBlurViewState macOSBlurViewState =
      MacOSBlurViewState.followsWindowActiveState;

  @override
  void initState() {
    super.initState();
    this.setWindowEffect(WindowEffect.transparent);
  }

  void setWindowEffect(WindowEffect? value) {
    Window.setEffect(
      effect: value!,
      color: this.color,
      dark: brightness == InterfaceBrightness.dark,
    );
    if (Platform.isMacOS) {
      if (brightness != InterfaceBrightness.auto) {
        Window.overrideMacOSBrightness(
          dark: brightness == InterfaceBrightness.dark,
        );
      }
    }
    this.setState(() => this.effect = value);
  }

  void setBrightness(InterfaceBrightness brightness) {
    this.brightness = brightness;
    if (this.brightness == InterfaceBrightness.dark) {
      color = Platform.isWindows ? Color(0xCC222222) : Colors.transparent;
    } else {
      color = Platform.isWindows ? Color(0x22DDDDDD) : Colors.transparent;
    }
    this.setWindowEffect(this.effect);
  }

  @override
  Widget build(BuildContext context) {
    return TitlebarSafeArea(
      child: Expanded(
        flex:1,
        child:
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'github.com/alexmercerind/flutter_acrylic',
                      style: TextStyle(
                        color: brightness.getForegroundColor(context),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: buildEffectMenu(context),
                ),
                buildActionButtonBar(context),
              ],
            ),
          ),

      ),
    );
  }



  ButtonBar buildActionButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      overflowButtonSpacing: 4.0,
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            setBrightness(
              brightness == InterfaceBrightness.dark
                  ? InterfaceBrightness.light
                  : InterfaceBrightness.dark,
            );
          }),
          child: Text(
            'Dark: ${(() {
              switch (brightness) {
                case InterfaceBrightness.light:
                  return 'light';
                case InterfaceBrightness.dark:
                  return 'dark';
                default:
                  return 'auto';
              }
            })()}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  SingleChildScrollView buildEffectMenu(BuildContext context) {
    return SingleChildScrollView(
      child: Theme(
        data: brightness.getIsDark(context)
            ? ThemeData.dark()
            : ThemeData.light(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: (Platform.isWindows
                  ? WindowEffect.values.take(7)
                  : WindowEffect.values)
              .map(
                (effect) => RadioListTile<WindowEffect>(
                  title: Text(
                    effect.toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: brightness.getForegroundColor(context),
                    ),
                  ),
                  value: effect,
                  groupValue: this.effect,
                  onChanged: this.setWindowEffect,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
