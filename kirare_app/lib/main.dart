import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kirare_app/bloc/scale_bloc.dart';
import 'package:kirare_app/recording_button_widget.dart';

void main() {
  runApp(const KirareApp());
}

class KirareApp extends StatelessWidget {
  const KirareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirare',
      home: BlocProvider(
        create: (context) => ScaleBloc(),
        child: const Scaffold(body: RecordingScreen()),
      ),
    );
  }
}

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
            child: RecordingButton(
              onRecord: () => bloc.add(ScaleRecordingStarted()),
              iconColor: Colors.white,
            ),
          );
        } else if (state is ScaleRecording) {
          bloc.add(ScaleRecordingPing());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RecordingButton(
                  onRecord: () => bloc.add(ScaleRecordingCancelled()),
                  iconColor: Colors.red,
                ),
                const SizedBox(height: 20),
                Text("Elapsed time: ${state.elasedTimeInSeconds}"),
              ],
            ),
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

class ResultScreen extends StatelessWidget {
  final Scale result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: Center(
        child: Text("Result: ${result.toString()}"),
      ),
    );
  }
}
