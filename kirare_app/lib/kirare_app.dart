import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kirare_app/bloc/scale_bloc.dart';
import 'package:kirare_app/screens/recording_screen.dart';

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
