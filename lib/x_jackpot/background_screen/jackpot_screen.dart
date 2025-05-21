import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/widget/circlar_progress_custom.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_backgroundvideo_hit_window.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_backgroundvideo_hit_window_fade_animation.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc2/jackpot_bloc2.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc2/jackpot_state2.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_backgroundvideo_hit.dart';

class JackpotHitScreen extends StatelessWidget {
  const JackpotHitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // JackpotBackgroundVideoHitWindowFadeAnimation(number: '1111', value: '33333', id: '2');

    //  BlocBuilder<JackpotBloc2, JackpotState2>(builder: (context, state) {
    //  return Container(
              // alignment: Alignment.center,
              // width: ConfigCustom.fixWidth/2,
              // height: ConfigCustom.fixHeight/2,
              // color:Colors.white38,
              // child:  Center(child: Text("${state.latestHit} - ${state.hits} -${state.showImagePage}",style:TextStyle(color:Colors.black,fontSize: 50))));});

    BlocBuilder<JackpotBloc2, JackpotState2>(
        builder: (context, state) {
          // Show error only if not connected and no hits
          if (!state.isConnected && state.hits.isEmpty && state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          // Show loading if not connected and no hits
          if (!state.isConnected && state.hits.isEmpty) {
            return circularProgessCustom();
          }

          // Show empty state if no hits
          if (state.hits.isEmpty) {
            return const Center(child: Text('',style:TextStyle(color:Colors.white)));
          }

          // Show JackpotImagePage for 10 seconds on new hit
          if (state.showImagePage && state.latestHit != null) {
            debugPrint('state.latestHit ${state.latestHit} - state.showImagePage: ${state.showImagePage}');
            return Stack(
              children: [
                JackpotBackgroundVideoHitWindowFadeAnimation(
                  id : state.latestHit!['id'].toString(),
                  number: state.latestHit!['machineNumber'].toString(),
                  value:state.latestHit!['amount'] ==[]? "0": state.latestHit!['amount'].toString(),
                ),
                Center(child: Text("${state.latestHit} - ${state.hits} -${state.showImagePage}",style:TextStyle(color:Colors.white)))
              ],
            );
          }

          return const Center(child: Text("",style:TextStyle(color:Colors.white)));
        },
      );
  }
}



