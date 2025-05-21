import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/color_custom.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/odometer_style3/odometer_child3.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc/video_bloc.dart';
import 'package:web_socket_channel/io.dart';


class JackpotDisplay extends StatefulWidget {
  const JackpotDisplay({Key? key}) : super(key: key);

  @override
  JackpotDisplayState createState() => JackpotDisplayState();
}

class JackpotDisplayState extends State<JackpotDisplay> {

  //screen 2: high limit | dozen |tripple | Weekly| monthly| vegas
  //screen 1: frequent | daily| daily golden | dozen | weekly

  //vegas
  double jackpotValueLevelVegas = 0.0;
  double previousJackpotValueLevelVegas = 0.0;
  //monthly
  double jackpotValueLevelZMonthly = 0.0;
  double previousJackpotValueLevelZMonthly = 0.0;

  //high limit
  double previousJackpotValueLevelHighLimit = 0.0;
  double jackpotValueLevelHighLimit = 0.0;

  //triple
  double jackpotValueLevelTripple = 0.0;
  double previousJackpotValueLevelTripple= 0.0;

  //weekly
  double jackpotValueLevelWeekly = 0.0;
  double previousJackpotValueLevelWeeekly = 0.0;

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
      channel = IOWebSocketChannel.connect(ConfigCustom.endpointWebSocket);
      channel.stream.listen(
        (message) {
          // Parse WebSocket message
          final data = jsonDecode(message);
          final level = data['Id'].toString();
          // debugPrint('level : ${data}');
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
            else if (level == "45") {
              previousJackpotValueLevelHighLimit = jackpotValueLevelHighLimit; // Save current as previous
              jackpotValueLevelHighLimit = newValue; // Update to new value
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
    return BlocBuilder<VideoBloc,ViddeoState>(
      builder:(context, state) {
      return Center(
        child: isConnected
            ?
            SizedBox(
              width: ConfigCustom.fixWidth,
              height:ConfigCustom.fixHeight,
              // child: screen2()
              child: state.id == 1 ? screen1() : screen2()
            )
            :  const Text("connecting ...",style: TextStyle(fontSize: 8.0,color: Colors.white,),),
        );
    },);
  }


  Widget screen1(){
    return Stack(
                children: [
                  //row top
                  Positioned(
                    top: ConfigCustom.fixHeight/5.65,
                    left:ConfigCustom.fixWidth/50,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelWeeekly, endValue: jackpotValueLevelWeekly,nameJP:"Weekly")),
                  Positioned(
                    top: ConfigCustom.fixHeight/5.65,
                    right: 16,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelDozen, endValue: jackpotValueLevelDozen,nameJP:"Dozen")),
                  //row center
                  Positioned(
                    top: ConfigCustom.fixHeight/2.23,
                    left:ConfigCustom.fixWidth/50,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelDailyGolden, endValue: jackpotValueLevelDailyGolden,nameJP:"Daily Golden")),
                  Positioned(
                    right:-16,
                    top: ConfigCustom.fixHeight/2.23,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelDaily, endValue: jackpotValueLevelDaily,nameJP:"Daily")),
                  //row bottom
                  Positioned(
                    bottom:ConfigCustom.fixHeight/6.75,
                    left:ConfigCustom.fixWidth/1.85,
                    child: GameOdometerChildStyle3(startValue: previousJackpotValueLevelFrequent, endValue:jackpotValueLevelFrequent ,nameJP:"Frequent"))
                ],
              );
  }


  Widget screen2(){
    return Stack(
                children: [
                  //row top
                  Positioned(
                    top: ConfigCustom.fixHeight/5.65,
                    left:ConfigCustom.fixWidth/50,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelVegas, endValue: jackpotValueLevelVegas,nameJP:"Vegas")),
                  Positioned(
                    top: ConfigCustom.fixHeight/5.65,
                    right: 16,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelZMonthly, endValue: jackpotValueLevelZMonthly,nameJP:"Monthly")),
                  //row center
                  Positioned(
                    top: ConfigCustom.fixHeight/2.23,
                    left:38,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelWeeekly, endValue: jackpotValueLevelWeekly,nameJP:"Weekly")),
                  Positioned(
                    right:-16,
                    top: ConfigCustom.fixHeight/2.23,
                    child: GameOdometerChildStyle3(startValue:  previousJackpotValueLevelTripple, endValue: jackpotValueLevelTripple,nameJP:"Tripple")),
                  //row bottom
                  Positioned(
                    bottom:ConfigCustom.fixHeight/6.75,
                    left:38,
                    child: GameOdometerChildStyle3(startValue: previousJackpotValueLevelDozen, endValue:jackpotValueLevelDozen ,nameJP:"Dozen")),
                  Positioned(
                    bottom:ConfigCustom.fixHeight/6.75,
                    right:0,
                    child: GameOdometerChildStyle3(startValue: previousJackpotValueLevelHighLimit, endValue:jackpotValueLevelHighLimit ,nameJP:"Hight Limit"))
                ],
              );
  }
}
