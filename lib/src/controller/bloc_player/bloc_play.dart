import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:newproject/src/controller/bloc_player/bloc_event.dart';
import 'dart:async';
import 'package:newproject/src/controller/bloc_player/bloc_state.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/repository/AudioPlayerRepository.dart';
import '../../model/repository/audioRepository.dart';
import '../../model/song.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  static double value = 0;
  AudioPlayer player = AudioPlayer();
  static int maxDuration = 0;
  static int durationValue = 0;
  static String name = '';
  static int index = 0;
  List songs = [];
  AudioPlayerRepository audioPlayerRepository = audioRepository();
  OnAudioQuery audioQuery = OnAudioQuery();
  //Song s = Song();
  static Future<List<SongModel>>? future = future;
  //OnAudioQuery().querySongs(
  //  sortType: null,
  //  orderType: OrderType.ASC_OR_SMALLER,
  //  uriType: UriType.EXTERNAL,
  //  ignoreCase: true,
  //);

  //double maxDuration = 0;

  AudioPlayerBloc()
      : super(AudioPlayerInitial(value, durationValue, maxDuration, '')) {
    on<AudioPlayerInitialized>(_onIntitialzed);
    on<AudioPlayed>(_onStarted);
    on<AudioPlaying>(_onPlaying);
    on<AudioPaused>(_onPaused);
    on<AudioSeeking>(_onSeeking);
    on<NextSong>(_onNextSong);
    on<PreviousSong>(_onPreviousSong);
  }

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
    }
    //setState(() {});
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _onIntitialzed(
      AudioPlayerInitialized event, Emitter<AudioPlayerState> emit) async {
    await requestPermission();
    //  print(player.state.toString());
    future = audioPlayerRepository.getAllSongs();
    emit(AudioPlayerInitial(value, durationValue, maxDuration, '',
        future: future!));
  }

  void _onStarted(AudioPlayed event, Emitter<AudioPlayerState> emit) async {
    //  print(player.state.toString());

    value = event.value;
    // s = audioPlayerRepository.getById(event.id!);
    //  if (!player.playing) {
    await player.setAudioSource(
      createPlaylist(event.data),
      initialIndex: event.index,
    );
    index = event.index!;
    player.play();
    maxDuration = player.duration!.inSeconds;
    name = event.name!;

    //  PreviousPerson = event.data[event.index! - 1].artist;
    // await player.play(Devent.data));
    // await player.setSource(Uri.parse(event.data!));
    //await player.play(event.data);
    // player.c.listen((Duration d) {
    //get the duration of audio
    //  maxDuration = player.duration!.inSeconds;
    // print('duratioin is $maxDuration');
    // });
    //   }

    //emit(AudioPlayerPlaying(
    //    value, durationValue, maxDuration, event.name!, index, future!));
    //if (player.playing) {
    player.positionStream.listen((p) {
      value = (p.inSeconds * 100) / maxDuration.toDouble();

      durationValue = p.inSeconds;
      print('value is $value');
      if (player.playing) {
        add(AudioPlaying(value: value, name: event.name));
      } else {
        add(AudioPaused());
      }
    });
    // }
  }

  void _onPlaying(AudioPlaying event, Emitter<AudioPlayerState> emit) async {
    await player.play();
    emit(AudioPlayerPlaying(
        value, durationValue, maxDuration, event.name ?? '', index, future!));
  }

  void _onPaused(AudioPaused event, Emitter<AudioPlayerState> emit) async {
    await player.pause();
    emit(AudioPlayerPaused(
        value, durationValue, maxDuration, name, index, future!));
  }

  void _onSeeking(AudioSeeking event, Emitter<AudioPlayerState> emit) async {
    Duration d = Duration(seconds: ((event.value * maxDuration) / 100).toInt());
    await player.seek(d);
    //  emit(AudioPlayerPlaying(value));
  }

  void _onNextSong(NextSong event, Emitter<AudioPlayerState> emit) async {
    index = player.currentIndex!;
    index++;
    maxDuration = event.data.duration!;
    await player.seekToNext();

    emit(AudioPlayerPlaying(
        0, 0, maxDuration, event.data.artist!, index, future!));
  }

  void _onPreviousSong(
      PreviousSong event, Emitter<AudioPlayerState> emit) async {
    index = player.currentIndex!;
    index--;
    maxDuration = event.data.duration!;
    await player.seekToPrevious();
    emit(AudioPlayerPlaying(
        0, 0, maxDuration, event.data.artist!, index, future!));
  }
}
