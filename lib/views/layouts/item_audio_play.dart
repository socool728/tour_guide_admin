import 'package:audioplayers/audioplayers.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ItemAudioPlay extends StatefulWidget {
  String url;
  bool? online;
  Function? onRemove;

  @override
  _ItemAudioPlayState createState() => _ItemAudioPlayState();

  ItemAudioPlay({
    required this.url,
    this.online,
    this.onRemove,
  });
}

class _ItemAudioPlayState extends State<ItemAudioPlay> {
  bool isPlaying = false;
  bool isShow = true;

  AudioCache _audioCache = AudioCache();

  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;

      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: Get.width * .9,
      margin: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5),
      decoration: BoxDecoration(boxShadow: appBoxShadow, color: Colors.white),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    if (!isPlaying) {
                      setState(() {});
                      await audioPlayer.audioCache;
                      await audioPlayer.setSourceUrl(widget.url);
                      await audioPlayer.resume();
                    } else {
                      await audioPlayer.pause();
                    }
                  },
                  icon: (isPlaying)
                      ? Icon(
                    Icons.pause,
                    color: Colors.red,
                  )
                      :  SvgPicture.asset(
                    "assets/svgs/playAudio.svg",
                    height: 20.sp,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                            // await audioPlayer.resume();
                          }),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${timeStampToDateTime(position.inMilliseconds, "mm:ss")}"),
                          Text("${timeStampToDateTime(duration.inMilliseconds - position.inMilliseconds, "mm:ss")}"),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (widget.onRemove != null){
                      Get.defaultDialog(
                          title: "Delete Audio",
                          content: Text(
                            "This media will be removed from the tour. Are you sure to delete this audio",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("Cancel")),
                            OutlinedButton(
                                onPressed: () {
                                  widget.onRemove!();
                                  Get.back();
                                },
                                child: Text("Delete")),
                          ]);
                    }
                  },
                  icon: SvgPicture.asset("assets/svgs/fluent_delete-20-filled.svg"),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.yellow.withOpacity(.7),
                boxShadow: appBoxShadow,
              ),
              child: Text(
                (widget.online ?? false) ? "Online" : "Offline",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
