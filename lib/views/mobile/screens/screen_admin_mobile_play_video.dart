import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart' as appinio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ScreenAdminMobilePlayVideo extends StatefulWidget {
  String path;
  bool? online;

  @override
  _ScreenAdminMobilePlayVideoState createState() => _ScreenAdminMobilePlayVideoState();

  ScreenAdminMobilePlayVideo({
    required this.path,
    this.online,
  });
}

class _ScreenAdminMobilePlayVideoState extends State<ScreenAdminMobilePlayVideo> {
  appinio.VideoPlayerController? videoPlayerController;
  appinio.CustomVideoPlayerController? customVideoPlayerController;
  int seconds = 0;
  bool loaded = false;
  bool online = false;

  @override
  void initState() {
    super.initState();
    print(widget.path);
    this.online = widget.online ?? false;
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
      customVideoPlayerController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Preview",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [],
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<void>(
            future: initializeVideoPlayer(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                seconds = videoPlayerController!.value.duration.inSeconds;
                loaded = true;
                videoPlayerController!.play();
                return Container(
                  height: Get.height,
                  width: Get.width,
                  child: appinio.CustomVideoPlayer(
                    customVideoPlayerController: appinio.CustomVideoPlayerController(
                      context: context,
                      videoPlayerController: videoPlayerController!,
                      customVideoPlayerSettings: appinio.CustomVideoPlayerSettings(
                          customVideoPlayerProgressBarSettings:
                              appinio.CustomVideoPlayerProgressBarSettings(allowScrubbing: true, showProgressBar: true),
                          showPlayButton: true,
                          showFullscreenButton: true,
                          controlBarAvailable: true),
                    ),
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }),
      ) /**/
      ,
    );
  }

  Future<void> initializeVideoPlayer() async {
    print(widget.path);
    if (online) {
      videoPlayerController = await appinio.VideoPlayerController.network(this.widget.path);
    } else {
      videoPlayerController = await appinio.VideoPlayerController.file(File(this.widget.path));
    }
    customVideoPlayerController = await appinio.CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController!,
    );
    await videoPlayerController!.initialize();
  }
}
