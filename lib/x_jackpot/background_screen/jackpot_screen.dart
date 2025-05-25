import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/widget/circlar_progress_custom.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/jackpot_backgroundvideo_hit_window_fade_animation.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc_socket_time/jackpot_bloc2.dart';
import 'package:playtech_transmitter_app/x_jackpot/background_screen/bloc_socket_time/jackpot_state2.dart';

class JackpotHitScreen extends StatelessWidget {
  const JackpotHitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // JackpotBackgroundVideoHitWindowFadeAnimation(number: '1111', value: '33333', id: '2');


   BlocSelector<JackpotBloc2, JackpotState2, Map<String, dynamic>?>(
      selector: (state) {
        // Select hit data only when showImagePage is true and latestHit exists
        if (state.showImagePage && state.latestHit != null) {
          return state.latestHit;
        }
        // Return null for loading, error, or empty states
        if (!state.isConnected && state.hits.isEmpty) {
          return {'isLoading': true, 'error': state.error};
        }
        return null;
      },
      builder: (context, hitData) {
        debugPrint('JackpotHitScreen BlocSelector: hitData=$hitData');
        // Loading state
        if (hitData != null && hitData.containsKey('isLoading')) {
          if (hitData['error'] != null) {
            return Center(child: Text('Error: ${hitData['error']}', style: const TextStyle(color: Colors.white)));
          }
          return circularProgessCustom();
        }
        // Empty state
        if (hitData == null) {
          return const Center(child: Text('', style: TextStyle(color: Colors.white)));
        }
        // Hit state
        return JackpotBackgroundVideoHitWindowFadeAnimation(
          id: hitData['id'].toString(),
          number: hitData['machineNumber'].toString(),
          value: hitData['amount'] == [] ? "0" : hitData['amount'].toString(),
        );
      },
    );

  }
}



