import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tour_guide_admin/controllers/tour_controller.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/helpers/helpers.dart';
import 'package:tour_guide_admin/models/stop.dart';
import 'package:tour_guide_admin/views/layouts/item_video_play.dart';

import '../../../helpers/firebase_utils.dart';
import '../../../widgets/input_field.dart';
import '../../layouts/item_audio_play.dart';

class ScreenAdminMobileEditStop extends StatefulWidget {
  Stop stop;
  String tour_id;
  double lat,lng;

  @override
  _ScreenAdminMobileEditStopState createState() =>
      _ScreenAdminMobileEditStopState();

  ScreenAdminMobileEditStop({
    required this.stop,
    required this.tour_id,
    required this.lat,
    required this.lng,
  });
}

class _ScreenAdminMobileEditStopState extends State<ScreenAdminMobileEditStop> {
  List<String> pickedStopVideosPaths = [];
  List<String> pickedStopImagesPaths = [];
  List<String> pickedStopAudiosPaths = [];
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
             leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(LocaleKeys.EditStop.tr),
        centerTitle: true,
      ),
      body: GetX<TourController>(
        init: Get.find<TourController>(),
        initState: (_) {},
        builder: (controller) {
          return CustomProgressWidget(
            loading: loading,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.sp),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InputField(
                      showBorder: true,
                      controller: controller.stopTitleController.value
                        ..text = widget.stop.name,

                      // text: widget.stop.name,
                      label: LocaleKeys.StopTitle.tr,
                      suffix: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            "assets/svgs/edit.svg",
                            height: 15.sp,
                            color: appPrimaryColor,
                          )),
                    ),
                    InputField(
                      showBorder: true,
                      controller: controller.stopNumberController.value
                        ..text = "${widget.stop.stop_number}",
                      label: LocaleKeys.StopNo.tr,
                      suffix: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            "assets/svgs/edit.svg",
                            height: 15.sp,
                            color: appPrimaryColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.StopDescription.tr,
                            style: normal_h2Style_bold,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                "assets/svgs/edit.svg",
                                height: 15.sp,
                                color: appPrimaryColor,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.sp),
                      padding: EdgeInsets.all(3.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: appBoxShadow),
                      child: InputField(
                        controller: controller.stopDescriptionController.value
                          ..text = widget.stop.description,
                        margin: EdgeInsets.zero,
                        maxLines: 10,
                        // label: "Description",
                        hint: LocaleKeys.WriteIntro.tr,
                        textStyle: normal_h4Style.copyWith(color: Colors.grey),
                        showBorder: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.sp, vertical: 8.sp),
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: appPrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.AttachMultipleVideos.tr,
                              style: normal_h3Style_bold.copyWith(
                                  color: Colors.white),
                            ),
                            SvgPicture.asset("assets/svgs/video.svg")
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomListviewBuilder(
                            itemBuilder: (BuildContext context, int index) {
                              return ItemVideoPlay(
                                url: widget.stop.stopVideosUrl[index],
                                onRemove: ()async{
                                  var ref = await FirebaseStorage.instance
                                      .refFromURL(
                                      widget.stop.stopVideosUrl[index]);
                                  widget.stop.stopVideosUrl.removeAt(index);
                                  ref.delete();
                                  await stopsRef
                                      .doc(widget.stop.id)
                                      .update(widget.stop.toMap());
                                  setState(() {});

                                },
                              );
                            },
                            itemCount: widget.stop.stopVideosUrl.length,
                            scrollDirection: CustomDirection.horizontal,
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            return CustomListviewBuilder(
                              itemCount: pickedStopVideosPaths.length,
                              scrollable: false,
                              scrollDirection: CustomDirection.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return ItemVideoPlay(
                                  url: pickedStopVideosPaths[index],
                                  online: false,
                                  onRemove: () {
                                    pickedStopVideosPaths.removeAt(index);
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          }),
                          Container(
                            height: Get.height * .15,
                            width: Get.height * .15,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await PickFile(['mp4', 'mov']).then((value) {
                                  this.pickedStopVideosPaths = value!.paths
                                      .map((e) => e.toString())
                                      .toList();
                                  setState(() {});
                                });
                              },
                              icon: Icon(Icons.add),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.sp, vertical: 8.sp),
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: appPrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.AttachMultipleImages.tr,
                              style: normal_h3Style_bold.copyWith(
                                  color: Colors.white),
                            ),
                            SvgPicture.asset("assets/svgs/image.svg")
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomListviewBuilder(
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * .18,
                                width: Get.width * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * .4,

                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                        widget.stop.stopImagesUrl[index]),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: "Delete Image",
                                        content: Text(
                                          "This media will be removed from the tour. Are you sure to delete this image",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          OutlinedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text("Cancel")),
                                          OutlinedButton(
                                              onPressed: () async {
                                                var ref = FirebaseStorage
                                                    .instance.refFromURL(widget.stop.stopImagesUrl[
                                                index]);
                                                ref.delete();
                                                widget.stop.stopImagesUrl.removeAt(index);
                                                await stopsRef.doc(widget.stop.id).update(widget.stop.toMap());
                                                setState(() {});
                                                Get.back();
                                              },
                                              child: Text("Delete")),
                                        ]);

                                  },
                                  icon:
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          shape: BoxShape.circle

                                        ),
                                          child: SvgPicture.asset("assets/svgs/fluent_delete.svg")),
                                ),
                              );
                            },
                            itemCount: widget.stop.stopImagesUrl.length,
                            scrollDirection: CustomDirection.horizontal,
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            return CustomListviewBuilder(
                              itemCount: pickedStopImagesPaths.length,
                              scrollable: false,
                              scrollDirection: CustomDirection.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return ItemVideoPlay(
                                  url: pickedStopImagesPaths[index],
                                  online: false,
                                  onRemove: () {
                                    pickedStopImagesPaths.removeAt(index);
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          }),
                          Container(
                            height: Get.height * .15,
                            width: Get.height * .15,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await PickFile(['png', 'jpg']).then((value) {
                                  this.pickedStopImagesPaths = value!.paths
                                      .map((e) => e.toString())
                                      .toList();
                                  setState(() {});
                                });
                              },
                              icon: Icon(Icons.add),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.sp, vertical: 8.sp),
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: appPrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.AttachMultipleAudio.tr,
                              style: normal_h3Style_bold.copyWith(
                                  color: Colors.white),
                            ),
                            SvgPicture.asset(
                                "assets/svgs/dashicons_format-audio.svg")
                          ],
                        ),
                      ),
                    ),
                    CustomListviewBuilder(
                      itemBuilder: (BuildContext context, int index) {
                        return ItemAudioPlay(
                          url: widget.stop.stopAudiosUrl[index],
                          onRemove: ()async{
                            var ref = await FirebaseStorage.instance
                                .refFromURL(
                                widget.stop.stopAudiosUrl[index]);
                            widget.stop.stopAudiosUrl.removeAt(index);
                            ref.delete();
                            await stopsRef
                                .doc(widget.stop.id)
                                .update(widget.stop.toMap());
                            setState(() {});

                          },
                        );
                      },
                      itemCount: widget.stop.stopAudiosUrl.length,
                      scrollDirection: CustomDirection.vertical,
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return CustomListviewBuilder(
                        itemCount: pickedStopAudiosPaths.length,
                        scrollable: false,
                        scrollDirection: CustomDirection.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemAudioPlay(
                            url: pickedStopAudiosPaths[index],
                            online: false,
                            onRemove: () {
                              pickedStopAudiosPaths.removeAt(index);
                              setState(() {});
                            },
                          );
                        },
                      );
                    }),
                    Container(
                      height: Get.height * .15,
                      width: Get.height * .15,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await PickFile(['mp3']).then((value) {
                            this.pickedStopAudiosPaths = value!.paths
                                .map((e) => e.toString())
                                .toList();
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    CustomButton(
                      text: LocaleKeys.Update.tr,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        var currentVideos = widget.stop.stopVideosUrl;
                        var currentAudios = widget.stop.stopAudiosUrl;
                        var currentImages = widget.stop.stopImagesUrl;
                        var newAudiosUrl =
                        await FirebaseUtils.uploadMultipleFiles(
                            pickedStopAudiosPaths,
                            "tours/${widget.tour_id}/stops/${widget.stop.id}/stopAudios/",
                            startIndex: currentAudios.length,
                            extension: "mp3");
                        var newImagesUrl =
                        await FirebaseUtils.uploadMultipleFiles(
                            pickedStopImagesPaths,
                            "tours/${widget.tour_id}/stops/${widget.stop.id}/stopImages/",
                            startIndex: currentImages.length,
                            extension: "png");
                        var newVideosUrl =
                        await FirebaseUtils.uploadMultipleFiles(
                            pickedStopVideosPaths,
                            "tours/${widget.tour_id}/stops/${widget.stop.id}/stopVideo/",
                            startIndex: currentVideos.length,
                            extension: "mp4");

                        currentImages = [...currentImages, ...newImagesUrl];
                        currentAudios = [...currentAudios, ...newAudiosUrl];
                        currentVideos = [...currentVideos, ...newVideosUrl];
                        await stopsRef.doc(widget.stop.id).set(widget.stop
                            .copyWith(
                            stopImagesUrl: currentImages,
                            stopAudiosUrl: currentAudios,
                            stopVideosUrl: currentVideos)
                            .toMap());
                        await stopsRef.doc(widget.stop.id).update({
                          "stop_number":int.tryParse(controller.stopNumberController.value.text),
                          "description":controller.stopDescriptionController.value.text,
                          "name":controller.stopTitleController.value.text,
                          "longitude":widget.lng,
                          "latitude":widget.lat
                        });
                        setState(() {
                          loading = true;
                        });
                        Get.back();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      width: Get.width * .45,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
