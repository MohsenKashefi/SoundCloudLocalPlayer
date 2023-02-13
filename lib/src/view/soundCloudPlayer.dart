import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newproject/components/button.dart';
import 'package:newproject/src/controller/bloc_player/bloc_event.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controller/bloc_player/bloc_play.dart';
import '../controller/bloc_player/bloc_state.dart';

class soundCloudPlayer extends StatelessWidget {
  //requestPermission() async {
  //  // Web platform don't support permissions methods.
  //  if (!kIsWeb) {
  //    bool permissionStatus = await _audioQuery.permissionsStatus();
  //    if (!permissionStatus) {
  //      await _audioQuery.permissionsRequest();
  //    }
  //  }
  //  setState(() {});
  //}

  //@override
  //void initState() {
  //  // TODO: implement initState
  //  super.initState();
  //  requestPermission();
  //}

  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final sliderValue =
        context.select((AudioPlayerBloc bloc) => bloc.state.value);
    final duration_value =
        context.select((AudioPlayerBloc bloc) => bloc.state.duration_Value);
    final maxDuration =
        context.select((AudioPlayerBloc bloc) => bloc.state.max_duration);
    final name = context.select((AudioPlayerBloc bloc) => bloc.state.name);
    final index = context.select((AudioPlayerBloc bloc) => bloc.state.index);

    final Future<List<SongModel>>? future =
        context.select((AudioPlayerBloc bloc) => bloc.state.future);

    //print(sliderValue);
    return Scaffold(
        appBar: AppBar(
          title: Text('soundCloud'),
        ),
        body: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
            builder: (context, state) {
          //if (state is AudioPlayerInitial) {
          /// if (future == null) {
          // return CircularProgressIndicator();
          // } else {
          return customWidget(state, sliderValue, context, duration_value,
              maxDuration, future, name, index);
          //  }

          //  } else if (state is AudioPlayerPlaying) {
          //  return customWidget(state);
          ////   } else {
          //     return Center(
          //     child: CircularProgressIndicator(),
          //  );
        }));
  }

  Widget customWidget(
      AudioPlayerState s,
      var sliderValue,
      BuildContext context,
      duration_value,
      maxDuration,
      Future<List<SongModel>>? future,
      String name,
      int index) {
    var size = MediaQuery.of(context).size;
    return
        // Center(
        //child:
        // Column(
        //    mainAxisAlignment: MainAxisAlignment.center,
        //  children: [
        Container(
            //  height: size.height * 0.9,
            //decoration: BoxDecoration(
            //    color: Colors.grey, borderRadius: BorderRadius.circular(5)),
            //margin: EdgeInsets.symmetric(
            //    horizontal: size.width * 0.09, vertical: size.height * 0.01),
            child: FutureBuilder<List<SongModel>>(
      // Default values:
      future: future,
      builder: (context, item) {
        if (item.data == null) return const CircularProgressIndicator();
        if (item.data!.isEmpty)
          return Center(child: const Text("Nothing found!"));
        // You can use [item.data!] direct or you can create a:
        // List<SongModel> songs = item.data!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FutureBuilder<Uint8List?>(
                    future: audioQuery.queryArtwork(
                      item.data![index].id,
                      ArtworkType.AUDIO,
                    ),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.data == null)
                        return Container(
                          height: 250.0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                      return Container(
                          width: 300,
                          height: 300,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      width: 50,
                                      height: 50,
                                      image: AssetImage(
                                        'assets/images/logo.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 11, vertical: 10),
                                          child: Text(
                                            item.data![index].artist!,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text((duration_value / 60)
                                        .toStringAsFixed(2)),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text((maxDuration / 60)
                                          .toStringAsFixed(2)))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Slider(
                                    activeColor: Colors.red,
                                    inactiveColor: Colors.grey,
                                    value: sliderValue > 100 ? 0 : sliderValue,
                                    onChanged: (double value) {
                                      context
                                          .read<AudioPlayerBloc>()
                                          .add(AudioSeeking(value: value));
                                      //audioPlayer.seek((value/1000).roundToDouble());
                                    },
                                    min: 0.0,
                                    max: 100),
                              )
                              //Container(
                              //  width: 800,
                              //  height: 50,
                              //  margin:
                              //      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              //  child: SizedBox(
                              //    width: 300,
                              //    height: 50,
                              //  ),
                              //  decoration: BoxDecoration(
                              //      color: Colors.grey,
                              //      borderRadius: BorderRadius.circular(10)),
                              //)
                            ],
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              opacity: 0.2,
                              image: MemoryImage(snapshot.data!),
                            ),
                            color: Colors.orange[200],
                            borderRadius: BorderRadius.circular(10),
                          ));
                    }),
                Container(
                  width: 300,
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      button(
                        icon: Icon(Icons.skip_previous_rounded),
                        pressing: () {
                          //context
                          //    .read<AudioPlayerBloc>()
                          //    .add(PreviousSong(item.data![index - 1], index));
                          context.read<AudioPlayerBloc>().add(AudioPlayed(
                              value: sliderValue,
                              data: item.data!,
                              index: index - 1,
                              name: item.data![index - 1].artist));
                        },
                      ),
                      button(
                          icon: s is AudioPlayerPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          pressing: s is AudioPlayerPlaying
                              ? () {
                                  context
                                      .read<AudioPlayerBloc>()
                                      .add(AudioPaused());
                                }
                              : () {
                                  context
                                      .read<AudioPlayerBloc>()
                                      .add(AudioPlaying(value: sliderValue));
                                }),
                      button(
                        icon: Icon(Icons.skip_next_rounded),
                        pressing: () {
                          //context
                          //    .read<AudioPlayerBloc>()
                          //    .add(PreviousSong(item.data![index + 1], index));
                          context.read<AudioPlayerBloc>().add(AudioPlayed(
                              value: sliderValue,
                              data: item.data!,
                              index: index + 1,
                              name: item.data![index + 1].artist));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.09, vertical: size.height * 0.01),
              height: 200,
              child: ListView.builder(
                itemCount: item.data!.length,
                itemBuilder: (context, index1) {
                  print(item.data![index1].data);
                  return ListTile(
                    title: Text(item.data![index1].title),
                    subtitle: Text(item.data![index1].artist ?? "No Artist"),
                    trailing: const Icon(Icons.arrow_forward_rounded),
                    leading: s is AudioPlayed
                        ? QueryArtworkWidget(
                            id: item.data![index1].id,
                            type: ArtworkType.AUDIO,
                          )
                        : null,
                    onTap: () {
                      context.read<AudioPlayerBloc>().add(AudioPlayed(
                          value: sliderValue,
                          data: item.data!,
                          index: index1,
                          name: item.data![index1].artist));
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    ));
    //      //],
    // )
    //   );
  }
}
