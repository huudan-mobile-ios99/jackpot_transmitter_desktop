import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/color_custom.dart';
import 'package:playtech_transmitter_app/jackpot_body.dart';
import 'package:playtech_transmitter_app/jackpot_view.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child_custom.dart';
import 'package:playtech_transmitter_app/odometer_style2/odometer_child2.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_child3.dart';
import 'package:web_socket_channel/io.dart';

class JackpotDisplay extends StatefulWidget {
  const JackpotDisplay({Key? key}) : super(key: key);

  @override
  JackpotDisplayState createState() => JackpotDisplayState();
}

class JackpotDisplayState extends State<JackpotDisplay> {
  // Settings (matching HTML optns)
  final String serverIp = "192.168.100.165";
  final String serverPort = "8080"; // WebSocket port
  final String level = "0"; // Jackpot level to display
  final double fontSize = 92.0; // Adjusted for Flutter (HTML was 102)
  final Color fontColor = ColorCustom.yellow_bg;
  final String fontFamily = 'OpenSans';
  final int animationSpeed = 2000; // Match HTML animation speed (2000ms)



  double jackpotValueLevel0 = 0.0;  // State variables for level 0
  double previousJackpotValueLevel0 = 0.0;
  double jackpotValueLevel1 = 0.0;  // State variables for level 1
  double previousJackpotValueLevel1 = 0.0;


  late IOWebSocketChannel channel; // WebSocket channel
  bool isConnected = false;
  int secondToReconnect = 5;

  @override
  void initState() {
    super.initState();
    // Connect to WebSocket
    connectToWebSocket();
  }

  void connectToWebSocket() {
    try {
      channel = IOWebSocketChannel.connect('ws://$serverIp:$serverPort');
      channel.stream.listen(
        (message) {
          // Parse WebSocket message
          final data = jsonDecode(message);
          // debugPrint("data data: $data");
          debugPrint("data message: $message");
          final level = data['Id'].toString();
          final newValue = double.tryParse(data['Value'].toString()) ?? 0.0;
          setState(() {
            if (level == "0") {
              previousJackpotValueLevel0 = jackpotValueLevel0; // Save current as previous
              jackpotValueLevel0 = newValue; // Update to new value
            } else if (level == "1") {
              previousJackpotValueLevel1 = jackpotValueLevel1; // Save current as previous
              jackpotValueLevel1 = newValue; // Update to new value
            }
            isConnected = true;
          });
        },
        onError: (error) {
          debugPrint("WebSocket error: $error");
          setState(() {
            isConnected = false;
          });
          // Attempt to reconnect after 5 seconds
          Future.delayed( Duration(seconds: secondToReconnect), connectToWebSocket);
        },
        onDone: () {
          debugPrint("WebSocket closed");
          setState(() {
            isConnected = false;
          });
          // Attempt to reconnect after 5 seconds
          Future.delayed( Duration(seconds: secondToReconnect), connectToWebSocket);
        },
      );
    } catch (e) {
      debugPrint("Failed to connect to WebSocket: $e");
      setState(() {
        isConnected = false;
      });
      // Attempt to reconnect after 5 seconds
      Future.delayed( Duration(seconds: secondToReconnect), connectToWebSocket);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: isConnected
            ?
            // JackpotBodyPage(startValue: previousJackpotValueLevel0, endValue: jackpotValueLevel0)
            // GameOdometerChildStyle2(startValue1: previousJackpotValueLevel0, endValue1: jackpotValueLevel0)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GameOdometerChildStyle3(startValue: previousJackpotValueLevel1, endValue: jackpotValueLevel1,nameJP:"Daily"),
                const SizedBox(height:16),
                GameOdometerChildStyle3(startValue: previousJackpotValueLevel0, endValue: jackpotValueLevel0,nameJP:"Frequent"),
              ],
            )
            // GameOdometerChild(startValue: previousJackpotValueLevel0, endValue: jackpotValueLevel0,)
            :  const Text(
                "Connecting ...",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
