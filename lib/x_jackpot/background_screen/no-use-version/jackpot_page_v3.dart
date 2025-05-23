import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/color_custom.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_child3.dart';
import 'package:web_socket_channel/io.dart';


class JackpotDisplayV3 extends StatefulWidget {
  const JackpotDisplayV3({Key? key}) : super(key: key);

  @override
  JackpotDisplayV3State createState() => JackpotDisplayV3State();
}

class JackpotDisplayV3State extends State<JackpotDisplayV3> {
  // Settings (matching HTML optns)
  final String serverIp = "192.168.100.165";
  final String serverPort = "8080"; // WebSocket port
  final String level = "0"; // Jackpot level to display
  final double fontSize = 92.0; // Adjusted for Flutter (HTML was 102)
  final Color fontColor = ColorCustom.yellow_bg;
  final String fontFamily = 'OpenSans';
  final int animationSpeed = 2000; // Match HTML animation speed (2000ms)


  double jackpotValueLevelFrequent = 0.0;
  double previousJackpotValueLevelFrequent = 0.0;


  late IOWebSocketChannel channel; // WebSocket channel
  bool isConnected = false;
  int secondToReconnect = 1;

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
          final data = jsonDecode(message);
          final level = data['Id'].toString();
          final newValue = double.tryParse(data['Value'].toString()) ?? 0.0;
          setState(() {
            if (level == "0") {
              previousJackpotValueLevelFrequent = jackpotValueLevelFrequent; // Save current as previous
              jackpotValueLevelFrequent = newValue; // Update to new value
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
            GameOdometerChildStyle3(startValue: previousJackpotValueLevelFrequent, endValue:jackpotValueLevelFrequent ,nameJP:"Frequent")
            :
            const Text("connecting ...",style: TextStyle(fontSize: 8.0,color: Colors.white,),),
      ),
    );
  }
}
