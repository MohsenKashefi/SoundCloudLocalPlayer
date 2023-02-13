import 'package:equatable/equatable.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class AudioPlayerState extends Equatable {
  final double value;
  final int duration_Value;
  final int max_duration;
  final Future<List<SongModel>>? future;
  final name;
  final index;

  const AudioPlayerState(
      this.value, this.duration_Value, this.max_duration, this.name, this.index,
      {this.future});

  @override
  List<Object> get props => [value, duration_Value, max_duration];
}

class AudioPlayerInitial extends AudioPlayerState {
  const AudioPlayerInitial(double value, int duration, int max_duration, name,
      {Future<List<SongModel>>? future})
      : super(
          value,
          duration,
          max_duration,
          '',
          0,
          future: future,
        );

  @override
  String toString() => 'value { value: $value }';
}

class AudioPlayerPlaying extends AudioPlayerState {
  const AudioPlayerPlaying(double value, int duration, int max_duration,
      String name, int index, Future<List<SongModel>> future)
      : super(value, duration, max_duration, name, index, future: future);
  @override
  String toString() => 'value { value: $value }';
}

class AudioPlayerPaused extends AudioPlayerState {
  const AudioPlayerPaused(double value, int duration, int max_duration,
      String name, int index, Future<List<SongModel>> future)
      : super(value, duration, max_duration, name, index, future: future);
  @override
  String toString() => 'value { value: $value }';
}

class AudioPlayerFailure extends AudioPlayerState {
  AudioPlayerFailure(double value, int duration)
      : super(0, 0, 0, '', 0, future: null);

  @override
  List<Object> get props => [];
}

class AudioPlayerComplete extends AudioPlayerState {
  AudioPlayerComplete() : super(0, 0, 0, '', 0, future: null);
}
