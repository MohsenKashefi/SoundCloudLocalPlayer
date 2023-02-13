import 'package:newproject/src/model/repository/AudioPlayerRepository.dart';
import 'package:newproject/src/model/song.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'AudioPlayerModelFactory.dart';

class audioRepository implements AudioPlayerRepository {
  @override
  getAllSongs() {
    OnAudioQuery audioQuery = OnAudioQuery();
    List<Song> audioPlayerModels;
    return OnAudioQuery().querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }
}
