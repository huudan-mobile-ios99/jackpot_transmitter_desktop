import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc2/jackpot_bloc2.dart';
import 'package:playtech_transmitter_app/x_jackpot/bloc2/jackpot_state2.dart';
import 'package:playtech_transmitter_app/x_jackpot/jackpot_image.dart';
import 'package:playtech_transmitter_app/x_jackpot/jackpot_page.dart';

class JackpotHitScreen extends StatelessWidget {
  const JackpotHitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JackpotBloc2(),
      child: BlocBuilder<JackpotBloc2, JackpotState2>(
          builder: (context, state) {

            // Show error only if not connected and no hits
            if (!state.isConnected && state.hits.isEmpty && state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }

            // Show loading if not connected and no hits
            if (!state.isConnected && state.hits.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show empty state if no hits
            if (state.hits.isEmpty) {
              return const Center(child: Text('no jackpot'));

            }

            // Show JackpotImagePage for 10 seconds on new hit
            if (state.showImagePage && state.latestHit != null) {
              return JackpotImagePage(
                number: state.latestHit!['machineNumber'].toString(),
                value: state.latestHit!['amount'].toString(),
              );
            }

            return Center(child: Text("view default"));
            // return JackpotDisplay();
          },
        ),
    );
  }
}
