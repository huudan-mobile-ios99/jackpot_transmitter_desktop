import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';
import 'package:playtech_transmitter_app/main.dart';





class WindowTitleBar extends StatelessWidget {
  final InterfaceBrightness brightness;
  const WindowTitleBar({Key? key, required this.brightness}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
         Container(
            width: MediaQuery.of(context).size.width,
            height: 32.0,
            color: Colors.transparent,
            child: MoveWindow(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  MinimizeWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      normal: Colors.transparent,
                      mouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.001)
                          : Colors.white.withOpacity(0.001),
                      mouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.001)
                          : Colors.white.withOpacity(0.001),
                    ),
                  ),
                  MaximizeWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      normal: Colors.transparent,
                      mouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.001)
                          : Colors.white.withOpacity(0.001),
                      mouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.001)
                          : Colors.white.withOpacity(0.001),
                    ),
                  ),
                  CloseWindowButton(
                    onPressed: () {
                      appWindow.close();
                    },
                    colors: WindowButtonColors(
                      iconNormal: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      iconMouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black
                          : Colors.white,
                      normal: Colors.transparent,
                      mouseOver: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.04)
                          : Colors.white.withOpacity(0.04),
                      mouseDown: brightness == InterfaceBrightness.light
                          ? Colors.black.withOpacity(0.08)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          );

  }
}
