import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker_advance/google_places_picker_advance.dart';
import 'package:tour_guide_admin/controllers/tour_controller.dart';
import 'package:tour_guide_admin/extensions/num_extensions.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/helpers/helpers.dart';
import 'package:tour_guide_admin/views/layouts/item_audio_play.dart';
import 'package:tour_guide_admin/views/layouts/item_video_play.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_add_stop.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_edit_stop.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_edit_tour_add_stop.dart';
import 'package:tour_guide_admin/widgets/input_field.dart';

import '../../../helpers/firebase_utils.dart';
import '../../../models/stop.dart';
import '../../../models/tour.dart';

class ScreenAdminMobileEditTour extends StatefulWidget {
  Tour tour;

  @override
  _ScreenAdminMobileEditTourState createState() =>
      _ScreenAdminMobileEditTourState();

  ScreenAdminMobileEditTour({
    required this.tour,
  });
}

class _ScreenAdminMobileEditTourState extends State<ScreenAdminMobileEditTour> {
  List<String> pickedVideosPaths = [];
  List<String> pickedImagesPaths = [];
  List<String> pickedAudiosPaths = [];
  double lat = 0;
  double lng = 0;
  bool loading = false;
  LatLng initPosition = LatLng(37.42796133580664,
      -122.085749655962); //initial Position cannot assign null values

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
          title: Text(LocaleKeys.EditTour.tr),
          centerTitle: true,
        ),
        body: GetX<TourController>(
          init: Get.put(TourController(widget.tour.id)),
          builder: (controller) {
            return CustomProgressWidget(
              text: "Updating Tour",
              loading: loading,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InputField(
                        showBorder: true,
                        text: widget.tour.title,
                        controller: controller.titleController.value
                          ..text = widget.tour.title,
                        label: LocaleKeys.TourTitle.tr,
                        suffix: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              "assets/svgs/edit.svg",
                              height: 15.sp,
                              color: appPrimaryColor,
                            )),
                      ),
                      InputField(
                        readOnly: true,
                          showBorder: true,
                          // controller: controller.startLocationController.value..text,
                          label: LocaleKeys.From.tr,
                          text: widget.tour.starting_point,
                          suffix: IconButton(
                            icon: SvgPicture.asset(
                              "assets/svgs/edit.svg",
                              height: 15.sp,
                              color: appPrimaryColor,
                            ),
                            onPressed: () {
                              // Get.to(ScreenAdminMobileMapAddTour());
                            },
                          )),
                      InputField(
                        showBorder: true,
                        text: widget.tour.ending_point,
                        label: LocaleKeys.To.tr,
                        suffix: IconButton(
                          icon: SvgPicture.asset(
                            "assets/svgs/edit.svg",
                            height: 15.sp,
                            color: appPrimaryColor,
                          ),
                          onPressed: () {
                            // Get.to(Scre     enAdminMobileMapAddTour());
                          },
                        ),
                      ),
                      StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return GestureDetector(
                            onTap: () async {
                              PickResult data = await Get.to(PlacePicker(
                                apiKey: googleAPIKey,
                                popOnPickResult: true,
                                strictbounds: true,
                                onPlacePicked: (result) {
                                  setState(() {
                                    controller.stopLatitude.value =
                                        result.geometry!.location.lat;
                                    controller.stopLongitude.value =
                                        result.geometry!.location.lng;
                                  });
                                },
                                initialPosition: initPosition,
                              ));

                              Get.to(ScreenEditTourAddStop(
                                tour_id: widget.tour.id,
                              ));
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.sp, vertical: 10.sp),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8.sp, vertical: 8.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: appPrimaryColor,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    LocaleKeys.AddStops.tr,
                                    style: normal_h3Style_bold.copyWith(
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: stopsRef
                            .where("tour_id", isEqualTo: widget.tour.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator.adaptive());
                          }
                          var stops = snapshot.data!.docs
                              .map((e) => Stop.fromMap(
                                  e.data() as Map<String, dynamic>))
                              .toList();

                          return Column(
                            children: [
                              CustomListviewBuilder(
                                itemCount: stops.length,
                                scrollable: false,
                                scrollDirection: CustomDirection.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  var stop = stops[index];
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.sp, vertical: 7.sp),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8.sp, vertical: 8.sp),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(32),
                                        color: appPrimaryColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            stop.name,
                                            style: normal_h3Style_bold.copyWith(
                                                color: Colors.white),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    Get.defaultDialog(
                                                        title: "Alert",
                                                        content: Text(
                                                            "Are you Sure to delete\n this Stop?"),
                                                        actions: [
                                                          OutlinedButton(
                                                              onPressed:
                                                                  () async {
                                                                await stopsRef
                                                                    .doc(
                                                                        stop.id)
                                                                    .delete()
                                                                    .then(
                                                                        (value) {
                                                                  Get.back();
                                                                });
                                                              },
                                                              child:
                                                                  Text("Yes")),
                                                          OutlinedButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child:
                                                                  Text("No")),
                                                        ]);
                                                  },
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 3),
                                                      child: SvgPicture.asset(
                                                        "assets/svgs/fluent_delete-20-filled.svg",
                                                        color: Colors.white,
                                                      ))),
                                              GestureDetector(
                                                  onTap: () async {
                                                    PickResult data =
                                                        await Get.to(
                                                            PlacePicker(
                                                      apiKey: googleAPIKey,
                                                      popOnPickResult: true,
                                                      strictbounds: true,
                                                      onPlacePicked: (result) {
                                                        setState(() {
                                                          lat = result.geometry!
                                                              .location.lat;
                                                          lng = result.geometry!
                                                              .location.lng;
                                                        });
                                                      },
                                                      initialPosition: LatLng(
                                                          stop.latitude,
                                                          stop.longitude),
                                                    ));
                                                    print(lat);
                                                    print(lng);
                                                    Get.to(
                                                        ScreenAdminMobileEditStop(
                                                      lat: lat,
                                                      lng: lng,
                                                      stop: stop,
                                                      tour_id: widget.tour.id,
                                                    ));
                                                  },
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.sp,
                                                              vertical: 5.sp),
                                                      child: SvgPicture.asset(
                                                        "assets/svgs/edit.svg",
                                                        color: Colors.white,
                                                      ))),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return CustomListviewBuilder(
                                    itemCount: controller.stops.value.length,
                                    scrollable: false,
                                    scrollDirection: CustomDirection.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var stop = controller.stops.value[index];
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.sp,
                                              vertical: 0.sp),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.sp, vertical: 4.sp),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            color: appPrimaryColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                stop.name,
                                                style: normal_h3Style_bold
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                          title: "Alert",
                                                          content: Text(
                                                              "Are you Sure to delete\n this Stop?"),
                                                          actions: [
                                                            OutlinedButton(
                                                                onPressed:
                                                                    () async {
                                                                  controller
                                                                      .stops
                                                                      .value
                                                                      .remove(
                                                                          stop);
                                                                  Get.back();
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                    "Yes")),
                                                            OutlinedButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    Text("No")),
                                                          ]);
                                                    },
                                                    icon: SvgPicture.asset(
                                                      "assets/svgs/fluent_delete-20-filled.svg",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {});
                                                      Get.to(
                                                          ScreenAdminMobileAddStop(
                                                        stop_id: stop.id,
                                                      ));
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InputField(
                              showBorder: true,
                              controller: controller
                                  .totalDistanceController.value
                                ..text =
                                    "${(widget.tour.total_distance / 1000).roundToNum(2)} km",
                              // text: "${(widget.tour.total_distance/1000).roundToNum(2)} km",
                              label: LocaleKeys.TotalDistance.tr,
                              suffix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    "assets/svgs/edit.svg",
                                    height: 15.sp,
                                    color: appPrimaryColor,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InputField(
                              showBorder: true,
                              controller: controller.totalTimeController.value
                                ..text = "${widget.tour.total_time} mints",
                              // text: "${widget.tour.total_time} mints",
                              label: LocaleKeys.TotalTime.tr,
                              suffix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    "assets/svgs/edit.svg",
                                    height: 15.sp,
                                    color: appPrimaryColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InputField(
                              showBorder: true,
                              label: LocaleKeys.TotalStops.tr,
                              controller: controller.totalStopController.value
                                ..text = "${widget.tour.total_stop}",
                              // text: "${widget.tour.total_stop}",
                              suffix: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    "assets/svgs/edit.svg",
                                    height: 15.sp,
                                    color: appPrimaryColor,
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InputField(
                              showBorder: true,
                              // text: widget.tour.source,
                              controller: controller.sourceController.value
                                ..text = widget.tour.source,
                              label: LocaleKeys.Source.tr,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.IntroductionVideoDescription.tr,
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
                          controller: controller.descriptionController.value..text=widget.tour.description,
                          margin: EdgeInsets.zero,
                          maxLines: 10,
                          // label: "Description",
                          hint: LocaleKeys.WriteIntro.tr,
                          textStyle:
                              normal_h4Style.copyWith(color: Colors.grey),
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomListviewBuilder(
                              itemCount: widget.tour.videosUrl.length,
                              scrollable: false,
                              scrollDirection: CustomDirection.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return ItemVideoPlay(
                                  url: widget.tour.videosUrl[index],
                                  online: true,
                                  onRemove: () async {
                                    var ref = await FirebaseStorage.instance
                                        .refFromURL(
                                            widget.tour.videosUrl[index]);
                                    widget.tour.videosUrl.removeAt(index);
                                    ref.delete();
                                    await toursRef
                                        .doc(widget.tour.id)
                                        .update(widget.tour.toMap());
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                            StatefulBuilder(builder: (context, setState) {
                              return CustomListviewBuilder(
                                itemCount: pickedVideosPaths.length,
                                scrollable: false,
                                scrollDirection: CustomDirection.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return ItemVideoPlay(
                                    url: pickedVideosPaths[index],
                                    online: false,
                                    onRemove: () {
                                      pickedVideosPaths.removeAt(index);
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
                                    this.pickedVideosPaths = value!.paths
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
                      Container(
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            StatefulBuilder(builder: (context, setState) {
                              return CustomListviewBuilder(
                                itemCount: widget.tour.imagesUrl.length,
                                scrollable: false,
                                scrollDirection: CustomDirection.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.sp),
                                        height: Get.height * 0.24,
                                        width: Get.width * 0.45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                          boxShadow: appBoxShadow,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                                widget.tour.imagesUrl[index]),
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
                                                            .instance
                                                            .refFromURL(widget
                                                                    .tour
                                                                    .imagesUrl[
                                                                index]);
                                                        ref.delete();
                                                        widget.tour.imagesUrl
                                                            .removeAt(index);
                                                        await toursRef
                                                            .doc(widget.tour.id)
                                                            .update(widget.tour
                                                                .toMap());
                                                        setState(() {});
                                                        Get.back();
                                                      },
                                                      child: Text("Delete")),
                                                ]);
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/svgs/fluent_delete.svg",
                                            color: appPrimaryColor,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.yellow.withOpacity(.7),
                                            boxShadow: appBoxShadow,
                                          ),
                                          child: Text(
                                            "Online",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                            StatefulBuilder(builder: (context, setState) {
                              return CustomListviewBuilder(
                                itemCount: pickedImagesPaths.length,
                                scrollable: false,
                                scrollDirection: CustomDirection.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.sp),
                                        height: Get.height * 0.24,
                                        width: Get.width * 0.45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                          boxShadow: appBoxShadow,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                File(pickedImagesPaths[index])),
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                                title: "Delete image",
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
                                                        pickedImagesPaths
                                                            .removeAt(index);
                                                        setState(() {});
                                                        Get.back();
                                                      },
                                                      child: Text("Delete")),
                                                ]);
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/svgs/fluent_delete.svg",
                                            color: appPrimaryColor,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Colors.yellow.withOpacity(.7),
                                            boxShadow: appBoxShadow,
                                          ),
                                          child: Text(
                                            "Offline",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  borderRadius: BorderRadius.circular(20)),
                              child: IconButton(
                                onPressed: () async {
                                  await PickFile(['jpg', 'png', 'jpeg'])
                                      .then((value) {
                                    this.pickedImagesPaths = value!.paths
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
                      // CustomListviewBuilder(
                      //   itemCount: widget.tour.imagesUrl.length,
                      //   scrollDirection: CustomDirection.horizontal,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 2.sp),
                      //       height: Get.height * 0.24,
                      //       width: Get.width * 0.45,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(12),
                      //         color: Colors.white,
                      //         boxShadow: appBoxShadow,
                      //         image: DecorationImage(
                      //           fit: BoxFit.cover,
                      //           image: CachedNetworkImageProvider(widget.tour.imagesUrl[index]),
                      //         ),
                      //       ),
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: SvgPicture.asset(
                      //           "assets/svgs/fluent_delete.svg",
                      //           color: appPrimaryColor,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      Container(
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
                      StatefulBuilder(builder: (context, setState) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              CustomListviewBuilder(
                                itemCount: widget.tour.audiosUrl.length,
                                scrollable: false,
                                scrollDirection: CustomDirection.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return ItemAudioPlay(
                                    url: widget.tour.audiosUrl[index],
                                    online: true,
                                    onRemove: () async {
                                      var ref = await FirebaseStorage.instance
                                          .refFromURL(
                                              widget.tour.audiosUrl[index]);
                                      await ref.delete();
                                      widget.tour.audiosUrl.removeAt(index);
                                      await toursRef
                                          .doc(widget.tour.id)
                                          .update(widget.tour.toMap());
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                              CustomListviewBuilder(
                                itemCount: pickedAudiosPaths.length,
                                scrollable: false,
                                scrollDirection: CustomDirection.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return ItemAudioPlay(
                                    url: pickedAudiosPaths[index],
                                    online: false,
                                    onRemove: () {
                                      pickedAudiosPaths.removeAt(index);
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                              Container(
                                height: Get.height * .15,
                                width: Get.height * .15,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20)),
                                child: IconButton(
                                  onPressed: () async {
                                    await PickFile([
                                      'mp3',
                                    ]).then((value) {
                                      this.pickedAudiosPaths = value!.paths
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
                        );
                      }),
                      CustomButton(
                        text: LocaleKeys.Update.tr,
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          var currentVideos = widget.tour.videosUrl;
                          var currentAudios = widget.tour.audiosUrl;
                          var currentImages = widget.tour.imagesUrl;
                          var newAudiosUrl = await FirebaseUtils.uploadMultipleFiles(
                                  pickedAudiosPaths,
                                  "tours/${widget.tour.id}/audios/",
                                  startIndex: currentAudios.length,
                                  extension: "mp3");
                          var newImagesUrl = await FirebaseUtils.uploadMultipleFiles(
                                  pickedImagesPaths,
                                  "tours/${widget.tour.id}/images/",
                                  startIndex: currentImages.length,
                                  extension: "png");
                          var newVideosUrl = await FirebaseUtils.uploadMultipleFiles(
                                  pickedVideosPaths,
                                  "tours/${widget.tour.id}/videos/",
                                  startIndex: currentVideos.length,
                                  extension: "mp4");

                          currentImages = [...currentImages, ...newImagesUrl];
                          currentAudios = [...currentAudios, ...newAudiosUrl];
                          currentVideos = [...currentVideos, ...newVideosUrl];
                          await toursRef.doc(widget.tour.id).set(widget.tour
                              .copyWith(
                                  imagesUrl: currentImages,
                                  audiosUrl: currentAudios,
                                  videosUrl: currentVideos)
                              .toMap());
                        await  toursRef.doc(widget.tour.id).update({
                            "title":controller.titleController.value.text,
                          "description":controller.descriptionController.value.text,
                          "source":controller.sourceController.value.text,
                          // "total_time":controller.totalTimeController.value.text,
                          // "total_distance":controller.totalDistanceController.value.text,


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
      ),
    );
  }
}
