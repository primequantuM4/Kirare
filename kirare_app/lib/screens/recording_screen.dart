import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kirare_app/bloc/scale_bloc.dart';

import 'package:kirare_app/widgets/recording_button_widget.dart';

import 'package:kirare_app/screens/result_screen.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ScaleBloc>();
    bloc.add(ScaleRefresh());

    return BlocConsumer<ScaleBloc, ScaleState>(
      listener: (context, state) {
        if (state is ScaleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Result: ${state.error.toString()}"),
            ),
          );
        } else if (state is ScaleResult) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(result: state.result),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ScaleInitial) {
          return Center(
            child: RecordingButtonWidget(
              onRecord: () => bloc.add(ScaleRecordingStarted()),
              iconColor: Colors.white,
              isRecording: false,
            ),
          );
        } else if (state is ScaleRecording) {
          bloc.add(ScaleRecordingPing());
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: RecordingButtonWidget(
                  onRecord: () => bloc.add(ScaleRecordingCancelled()),
                  iconColor: Colors.red,
                  isRecording: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Elapsed time: ${state.elasedTimeInSeconds}")
            ],
          );
        } else if (state is ScaleRecorded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          bloc.add(ScaleRefresh());
          return Text("Unknown state: ${state.toString()}");
        }
      },
    );
  }
}
