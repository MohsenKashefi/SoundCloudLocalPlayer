import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newproject/src/controller/bloc_player/bloc_event.dart';
import 'package:newproject/src/controller/bloc_player/bloc_play.dart';
import 'package:newproject/src/controller/bloc_player/bloc_state.dart';
import 'package:newproject/src/view/soundCloudPlayer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => AudioPlayerBloc()..add(AudioPlayerInitialized()),
      child: soundCloudPlayer(),
    ));
  }
}
