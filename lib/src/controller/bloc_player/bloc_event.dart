import 'package:equatable/equatable.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object> get props => [];
}

class AudioPlayerInitialized extends AudioPlayerEvent {
  const AudioPlayerInitialized();
}

class AudioPlayed extends AudioPlayerEvent {
  const AudioPlayed(
      {required this.value,
      this.data,
      this.durationValue,
      this.maxDuration,
      this.index,
      this.name});
  final double value;
  final int? index;
  final data;
  final int? durationValue;
  final int? maxDuration;
  final String? name;
}

class AudioPaused extends AudioPlayerEvent {
  const AudioPaused();
}

class AudioResumed extends AudioPlayerEvent {
  const AudioResumed();
}

class AudioSeeking extends AudioPlayerEvent {
  const AudioSeeking(
      {required this.value, this.durationValue, this.maxDuration, this.name});
  final double value;
  final int? durationValue;
  final int? maxDuration;
  final String? name;
}

class NextSong extends AudioPlayerEvent {
  final SongModel data;
  final int index;
  const NextSong(this.data, this.index);
}

class PreviousSong extends AudioPlayerEvent {
  final SongModel data;
  final int index;
  const PreviousSong(this.data, this.index);
}

class AudioPlaying extends AudioPlayerEvent {
  const AudioPlaying(
      {required this.value,
      this.durationValue,
      this.maxDuration,
      this.name,
      this.index});
  final double value;
  final int? durationValue;
  final int? maxDuration;
  final String? name;
  final index;

  @override
  List<Object> get props => [value, durationValue!, maxDuration!, name!, index];
}
