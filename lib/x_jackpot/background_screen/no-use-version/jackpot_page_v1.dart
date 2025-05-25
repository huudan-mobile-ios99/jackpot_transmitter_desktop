import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/color_custom.dart';
import 'package:playtech_transmitter_app/widget/jackpot_body.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child_custom.dart';
import 'package:playtech_transmitter_app/odometer_style2/odometer_child2.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_child3.dart';
import 'package:web_socket_channel/io.dart';
//vegas :4
//monhtly:46
//weekly:3
//triple:35
//dozen : 2

//daily golden:34
//daily:1
//Frequent: 0
//screen resolution:1872x2600

class JackpotDisplayV1 extends StatefulWidget {
  const JackpotDisplayV1({Key? key}) : super(key: key);

  @override
  JackpotDisplayV1State createState() => JackpotDisplayV1State();
}

class JackpotDisplayV1State extends State<JackpotDisplayV1> {
  // Settings (matching HTML optns)
  final String serverIp = "192.168.100.165";
  final String serverPort = "8080"; // WebSocket port
  final String level = "0"; // Jackpot level to display
  final double fontSize = 92.0; // Adjusted for Flutter (HTML was 102)
  final Color fontColor = ColorCustom.yellow_bg;
  final String fontFamily = 'OpenSans';
  final int animationSpeed = 2000; // Match HTML animation speed (2000ms)


  //vegas
  double jackpotValueLevelVegas = 0.0;
  double previousJackpotValueLevelVegas = 0.0;
  //monthly
  double jackpotValueLevelZMonthly = 0.0;
  double previousJackpotValueLevelZMonthly = 0.0;

  //weekly
  double jackpotValueLevelWeekly = 0.0;
  double previousJackpotValueLevelWeeekly = 0.0;
  //triple
  double jackpotValueLevelTripple = 0.0;
  double previousJackpotValueLevelTripple= 0.0;

  //dozen
  double jackpotValueLevelDozen = 0.0;
  double previousJackpotValueLevelDozen= 0.0;

  //daily golden
  double jackpotValueLevelDailyGolden = 0.0;
  double previousJackpotValueLevelDailyGolden= 0.0;

  //daily
  double jackpotValueLevelDaily = 0.0;
  double previousJackpotValueLevelDaily= 0.0;

  //frequent
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
          // Parse WebSocket message
          final data = jsonDecode(message);
          final level = data['Id'].toString();
          final newValue = double.tryParse(data['Value'].toString()) ?? 0.0;
          setState(() {
            if (level == "0") {
              previousJackpotValueLevelFrequent = jackpotValueLevelFrequent; // Save current as previous
              jackpotValueLevelFrequent = newValue; // Update to new value
            }
            else if (level == "1") {
              previousJackpotValueLevelDaily = jackpotValueLevelDaily; // Save current as previous
              jackpotValueLevelDaily = newValue; // Update to new value
            }

            else if (level == "2") {
              previousJackpotValueLevelDozen = jackpotValueLevelDozen; // Save current as previous
              jackpotValueLevelDozen = newValue; // Update to new value
            }
            else if (level == "3") {
              previousJackpotValueLevelWeeekly = jackpotValueLevelWeekly; // Save current as previous
              jackpotValueLevelWeekly = newValue; // Update to new value
            }
            else if (level == "34") {
              previousJackpotValueLevelDailyGolden = jackpotValueLevelDailyGolden; // Save current as previous
              jackpotValueLevelDailyGolden = newValue; // Update to new value
            }
            else if (level == "35") {
              previousJackpotValueLevelTripple = jackpotValueLevelTripple; // Save current as previous
              jackpotValueLevelTripple = newValue; // Update to new value
            }
            else if (level == "46") {
              previousJackpotValueLevelZMonthly = jackpotValueLevelZMonthly; // Save current as previous
              jackpotValueLevelZMonthly = newValue; // Update to new value
            }
            else if (level == "4") {
              previousJackpotValueLevelVegas = jackpotValueLevelVegas; // Save current as previous
              jackpotValueLevelVegas = newValue; // Update to new value
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
          Future.delayed(Duration(seconds: secondToReconnect), connectToWebSocket);
        },
      );
    } catch (e) {
      debugPrint("Failed to connect to WebSocket: $e");
      setState(() {
        isConnected = false;
      });
      // Attempt to reconnect after 5 seconds
      Future.delayed(Duration(seconds: secondToReconnect), connectToWebSocket);
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
            // GameOdometerChild(startValue: previousJackpotValueLevelVegas, endValue: jackpotValueLevelVegas)
            // GameOdometerChildStyle2(startValue1: previousJackpotValueLevelVegas, endValue1: jackpotValueLevelVegas)
            GameOdometerChildStyle3(startValue: previousJackpotValueLevelFrequent, endValue:jackpotValueLevelFrequent ,nameJP:"Frequent")

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         GameOdometerChildStyle3(startValue: previousJackpotValueLevelVegas, endValue:jackpotValueLevelVegas ,nameJP:"Vegas"),
            //         GameOdometerChildStyle3(startValue:  previousJackpotValueLevelZMonthly, endValue: jackpotValueLevelZMonthly,nameJP:"Monthly"),
            //         GameOdometerChildStyle3(startValue:  previousJackpotValueLevelWeeekly, endValue: jackpotValueLevelWeekly,nameJP:"Weekly"),
            //       ],
            //     ),
            //     const SizedBox(height: 64,),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         GameOdometerChildStyle3(startValue: previousJackpotValueLevelTripple, endValue:jackpotValueLevelTripple ,nameJP:"Tripple"),
            //         GameOdometerChildStyle3(startValue:  previousJackpotValueLevelDozen, endValue: jackpotValueLevelDozen,nameJP:"Dozen"),
            //         GameOdometerChildStyle3(startValue:  previousJackpotValueLevelDailyGolden, endValue: jackpotValueLevelDailyGolden,nameJP:"Daily Golden"),
            //       ],
            //     ),
            //     const SizedBox(height: 64,),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         GameOdometerChildStyle3(startValue: previousJackpotValueLevelFrequent, endValue:jackpotValueLevelFrequent ,nameJP:"Frequent")
            //       ],
            //     )
            //   ],
            // )
            :  const Text("connecting ...",style: TextStyle(fontSize: 8.0,color: Colors.white,),),
      ),
    );
  }
}
