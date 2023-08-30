import 'dart:io';

import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tour_guide_admin/helpers/helpers.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_play_video.dart';

class ItemVideoPlay extends StatefulWidget {
  String url;
  Function()? onRemove;
  bool? online;

  @override
  _ItemVideoPlayState createState() => _ItemVideoPlayState();

  ItemVideoPlay({
    required this.url,
    this.onRemove,
    this.online,
  });
}

class _ItemVideoPlayState extends State<ItemVideoPlay> {
  late File thumbnail;
  bool online = false;

  @override
  void initState() {
    super.initState();
    this.online = widget.online ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: getVideoThumbnail(widget.url),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: 5),
            height: (SizerUtil.orientation == Orientation.portrait) ? Get.height * .18 : Get.width * .18,
            // width: Get.width*.36,
            width: (SizerUtil.orientation == Orientation.portrait) ? Get.width * .4 : Get.height * .4,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        thumbnail = snapshot.data!;

        return GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: (SizerUtil.orientation == Orientation.portrait) ? Get.height * .18 : Get.width * .18,
                // width: Get.width*.36,
                width: (SizerUtil.orientation == Orientation.portrait) ? Get.width * .4 : Get.height * .4,

                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: appBoxShadow,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: FileImage(File(thumbnail.path)),
                    )),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                Get.to(ScreenAdminMobilePlayVideo(
                                  path: widget.url,
                                  online: online,
                                ));
                              },
                              icon: Icon(
                                Icons.play_circle_fill,
                                color: appPrimaryColor,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                if (widget.onRemove != null) {
                                  Get.defaultDialog(
                                      title: "Delete video",
                                      content: Text(
                                        "This media will be removed from the tour. Are you sure to delete this video",
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
                              icon: SvgPicture.asset(
                                "assets/svgs/fluent_delete.svg",
                                color: appPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
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
      },
    );
  }
}
