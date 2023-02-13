import 'package:newproject/src/model/song.dart';

class AudioPlayerModelFactory {
  static List<Song> getAudioPlayerModels() {
    return [
      Song(
          id: "1",
          name: "The first song",
          isPlaying: false,
          path: "audio/1.mp3"),
      Song(
        id: "2",
        name: "The second song",
        isPlaying: false,
        path: "audio/2.mp3",
      )
    ];
  }
}
