// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:playtech_transmitter_app/color_custom.dart';
// import 'package:playtech_transmitter_app/functions.dart';
// import 'package:playtech_transmitter_app/odometer.dart';
// import 'package:web_socket_channel/io.dart';

// class JackpotDisplayV1 extends StatefulWidget {
//   const JackpotDisplayV1({Key? key}) : super(key: key);

//   @override
//   JackpotDisplayV1State createState() => JackpotDisplayV1State();
// }

// class JackpotDisplayV1State extends State<JackpotDisplayV1> {
//   // Settings (matching HTML optns)
//   final String serverIp = "192.168.100.165";
//   final String serverPort = "8080"; // WebSocket port
//   final String level = "0"; // Jackpot level to display
//   final double fontSize = 92.0; // Adjusted for Flutter (HTML was 102)
//   final Color fontColor = ColorCustom.yellow_bg;
//   final String fontFamily = 'OpenSans';
//   final int animationSpeed = 2000; // Match HTML animation speed (2000ms)

//   // State variables
//   double jackpotValue = 0.0; // Current jackpot value
//   late IOWebSocketChannel channel; // WebSocket channel
//   bool isConnected = false;
//   int secondToReconnect = 5;

//   @override
//   void initState() {
//     super.initState();
//     // Connect to WebSocket
//     connectToWebSocket();
//   }

//   void connectToWebSocket() {
//     try {
//       channel = IOWebSocketChannel.connect('ws://$serverIp:$serverPort');
//       channel.stream.listen(
//         (message) {
//           // Parse WebSocket message
//           final data = jsonDecode(message);
//           if (data['Id'] == level) {
//             final newValue = double.tryParse(data['Value'].toString()) ?? 0.0;
//             setState(() {
//               jackpotValue = newValue;
//               isConnected = true;
//             });
//           }
//         },
//         onError: (error) {
//           debugPrint("WebSocket error: $error");
//           setState(() {
//             isConnected = false;
//           });
//           // Attempt to reconnect after 5 seconds
//           Future.delayed( Duration(seconds: secondToReconnect), connectToWebSocket);
//         },
//         onDone: () {
//           debugPrint("WebSocket closed");
//           setState(() {
//             isConnected = false;
//           });
//           // Attempt to reconnect after 5 seconds
//           Future.delayed( Duration(seconds: secondToReconnect), connectToWebSocket);
//         },
//       );
//     } catch (e) {
//       debugPrint("Failed to connect to WebSocket: $e");
//       setState(() {
//         isConnected = false;
//       });
//       // Attempt to reconnect after 5 seconds
//       Future.delayed( Duration(seconds: secondToReconnect), connectToWebSocket);
//     }
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: isConnected
//             ?
//             GameOdometerChild(startValue: 100, endValue: jackpotValue.toInt(),droppedJP: false, )
//             // AnimatedDefaultTextStyle(
//             //     duration: Duration(milliseconds: animationSpeed),
//             //     style: TextStyle(
//             //       fontSize: fontSize,
//             //       color: fontColor,
//             //       letterSpacing: 12.0,
//             //       fontFamily: fontFamily,
//             //       fontFamilyFallback: const ['Arial', 'sans-serif'], // Fallback fonts
//             //       fontWeight: FontWeight.bold,
//             //       shadows: const [
//             //         Shadow(
//             //           color: Colors.white10,
//             //           offset: Offset(8, 8),
//             //           blurRadius: 8,
//             //         ),
//             //       ],
//             //     ),
//             //     child: Text(
//             //       '\$${formatNumber(jackpotValue)}', // Display with commas and 2 decimal places
//             //     ),
//             //   )
//             : const Text(
//                 "Connecting to WebSocket...",
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.white,
//                 ),
//               ),
//       ),
//     );
//   }
// }
