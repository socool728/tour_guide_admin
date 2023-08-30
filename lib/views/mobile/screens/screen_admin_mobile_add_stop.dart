import 'dart:io';

import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';

import '../../../controllers/tour_controller.dart';
import '../../../helpers/helpers.dart';
import '../../../widgets/input_field.dart';
import '../../layouts/item_audio_play.dart';
import '../../layouts/item_video_play.dart';

class ScreenAdminMobileAddStop extends StatefulWidget {
  String stop_id;

  @override
  _ScreenAdminMobileAddStopState createState() => _ScreenAdminMobileAddStopState();

  ScreenAdminMobileAddStop({
    required this.stop_id,
  });
}

class _ScreenAdminMobileAddStopState extends State<ScreenAdminMobileAddStop> {
  @override
  Widget build(BuildContext context) {
    Orientation portrait = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(LocaleKeys.AddStop.tr),
          centerTitle: true,
        ),
        body: GetX<TourController>(
          init: Get.find<TourController>(),
          initState: (state) {},
          builder: (controller) {
            return CustomProgressWidget(
              text: controller.wait.value,
              loading: controller.loading.value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InputField(
                        showBorder: true,
                        controller: controller.stopTitleController.value,
                        label: LocaleKeys.StopTitle.tr,
                        text: controller.stopsNamesMap[widget.stop_id] ?? "",
                      ),
                      InputField(
                        showBorder: true,
                        controller: controller.stopNumberController.value,
                        label: LocaleKeys.StopNo.tr,
                        readOnly: true,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              LocaleKeys.StopDescription.tr,
                              style: normal_h2Style_bold,
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.sp),
                        padding: EdgeInsets.all(3.sp),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: appBoxShadow),
                        child: InputField(
                          controller: controller.stopDescriptionController.value,
                          text: controller.stopsDescriptionsMap[widget.stop_id] ?? "",
                          margin: EdgeInsets.zero,
                          maxLines: 10,
                          // label: "Description",
                          hint: LocaleKeys.WriteIntro.tr,
                          textStyle: normal_h4Style.copyWith(color: Colors.grey),
                          showBorder: false,
                        ),
                      ),

                      //Stop Video
                      GestureDetector(
                        onTap: () async {
                          await PickFile([
                            'mp4',
                          ]).then((value) {
                            controller.stopsVideosMap[widget.stop_id] = [];

                            controller.stopsVideosMap[widget.stop_id] = value!.paths.map((e) => e.toString()).toList();
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                          margin: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: appPrimaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.AttachMultipleVideos.tr,
                                style: normal_h3Style_bold.copyWith(color: Colors.white),
                              ),
                              SvgPicture.asset("assets/svgs/video.svg")
                            ],
                          ),
                        ),
                      ),
                      ((controller.stopsVideosMap[widget.stop_id] ?? []).isEmpty)
                          ? SizedBox()
                          : Container(
                              height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * .18,
                              child: CustomListviewBuilder(
                                itemBuilder: (BuildContext context, int index) {
                                  return ItemVideoPlay(
                                    url: (controller.stopsVideosMap[widget.stop_id] ?? [])[index],
                                    onRemove: () {
                                      (controller.stopsVideosMap[widget.stop_id] ?? []).removeAt(index);
                                      setState(() {});
                                    },
                                  );
                                },
                                itemCount: (controller.stopsVideosMap[widget.stop_id] ?? []).length,
                                scrollDirection: CustomDirection.horizontal,
                              ),
                            ),

                      GestureDetector(
                        onTap: () async {
                          await PickFile(['png', 'jpg', 'jpeg']).then((value) {
                            controller.stopsImagesMap[widget.stop_id] = [];

                            controller.stopsImagesMap[widget.stop_id] = value!.paths.map((e) => e.toString()).toList();
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                          margin: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: appPrimaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.AttachMultipleImages.tr,
                                style: normal_h3Style_bold.copyWith(color: Colors.white),
                              ),
                              SvgPicture.asset("assets/svgs/image.svg")
                            ],
                          ),
                        ),
                      ),
                      ((controller.stopsImagesMap[widget.stop_id] ?? []).isEmpty)
                          ? SizedBox()
                          : Container(
                              height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * .18,
                              child: CustomListviewBuilder(
                                itemBuilder: (BuildContext context, int index) {
                                  controller.imageIndex = index;
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: (portrait == Orientation.portrait) ? Get.height * .24 : Get.width * .24,
                                    // width: Get.width*.36,
                                    width: (portrait == Orientation.portrait) ? Get.width * .4 : Get.height * .4,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(
                                          File((controller.stopsImagesMap[widget.stop_id] ?? [])[index]),
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        (controller.stopsImagesMap[widget.stop_id] ?? []).removeAt(index);
                                        setState(() {});
                                      },
                                      icon: SvgPicture.asset("assets/svgs/fluent_delete.svg"),
                                    ),
                                  );
                                },
                                itemCount: (controller.stopsImagesMap[widget.stop_id] ?? []).length,
                                scrollDirection: CustomDirection.horizontal,
                              ),
                            ),

                      GestureDetector(
                        onTap: () async {
                          await PickFile(
                            [
                              'mp3',
                            ],
                          ).then((value) {
                            controller.stopsAudiosMap[widget.stop_id] = [];

                            controller.stopsAudiosMap[widget.stop_id] = value!.paths.map((e) => e.toString()).toList();
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                          margin: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: appPrimaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.AttachMultipleAudio.tr,
                                style: normal_h3Style_bold.copyWith(color: Colors.white),
                              ),
                              SvgPicture.asset("assets/svgs/dashicons_format-audio.svg")
                            ],
                          ),
                        ),
                      ),
                      ((controller.stopsAudiosMap[widget.stop_id] ?? []).isEmpty)
                          ? SizedBox()
                          : StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                            return CustomListviewBuilder(
                              itemBuilder: (BuildContext context, int index) {
                                return ItemAudioPlay(
                                  url: (controller.stopsAudiosMap[widget.stop_id] ?? [])[index],
                                  onRemove: () {
                                    (controller.stopsAudiosMap[widget.stop_id] ?? []).removeAt(index);
                                  },
                                );
                              },
                              itemCount: (controller.stopsAudiosMap[widget.stop_id] ?? []).length,
                              scrollDirection: CustomDirection.vertical,
                            );
                      },),

                      CustomButton(
                        text: LocaleKeys.Save.tr,
                        onPressed: () async {
                          // controller.saveStop(widget.stop_id);
                          // controller.stops.refresh();
                          // controller.update();

                          var response=controller.saveStop(widget.stop_id);
                          if (response=='success') {
                            Get.snackbar("Success", "Stop Added");
                            controller.stops.refresh();
                            controller.update();
                            Navigator.pop(context);
                          }
                          else{
                            Get.snackbar("Alert", response.toString());
                          }
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
      ),
    );
  }
}
