import 'dart:io';

import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

// import 'package:google_places_picker_advance/google_places_picker_advance.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker_advance/google_places_picker_advance.dart';
import 'package:tour_guide_admin/controllers/tour_controller.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/helpers/firebase_utils.dart';
import 'package:tour_guide_admin/views/layouts/item_audio_play.dart';
import 'package:tour_guide_admin/views/layouts/item_video_play.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_add_stop.dart';
import 'package:tour_guide_admin/widgets/input_field.dart';

import '../../../helpers/helpers.dart';
import '../../../helpers/location_utils.dart';

class ScreenAdminMobileAddTour extends StatefulWidget {
  @override
  _ScreenAdminMobileAddTourState createState() => _ScreenAdminMobileAddTourState();
}

class _ScreenAdminMobileAddTourState extends State<ScreenAdminMobileAddTour> {
  var controller = Get.put(TourController(FirebaseUtils.newId.toString()));

  LatLng initPosition = LatLng(37.42796133580664, -122.085749655962); //initial Position cannot assign null values

  GoogleMapController? mapController;

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
          title: Text(LocaleKeys.UploadTour.tr),
          centerTitle: true,
        ),
        body: FutureBuilder<bool>(
            future: checkPermissionStatus(),
            builder: (context, permissionSnapshot) {
              if (permissionSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              }

              if (permissionSnapshot.data! == false) {
                return Center(
                  child: Column(
                    children: [
                      Text("Location access is required"),
                      CustomButton(
                          text: "Retry",
                          onPressed: () {
                            setState(() {});
                          })
                    ],
                  ),
                );
              }

              return FutureBuilder<Position>(
                  future: Geolocator.getCurrentPosition(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CupertinoActivityIndicator());
                    }

                    initPosition = LatLng(snapshot.data!.latitude, snapshot.data!.longitude);

                    return Obx(() {
                      return CustomProgressWidget(
                        loading: controller.loading.value,
                        text: controller.wait.value,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: SingleChildScrollView(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputField(
                                  showBorder: true,
                                  controller: controller.titleController.value,
                                  label: LocaleKeys.TourTitle.tr,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 10.sp),
                                  padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 2.sp),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: appPrimaryColor, width: 1)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        controller.StartAddress.value,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: normal_h3Style.copyWith(color: appPrimaryColor),
                                      )),
                                      IconButton(
                                        onPressed: () async {
                                          PickResult data = await Get.to(PlacePicker(
                                            apiKey: googleAPIKey,
                                            popOnPickResult: true,
                                            onPlacePicked: (result) {
                                              setState(() {
                                                controller.StartAddress.value = result.formattedAddress.toString();

                                                controller.tourStartLng.value = result.geometry!.location.lng;
                                                controller.tourStartLat.value = result.geometry!.location.lat;
                                              });
                                            },
                                            initialPosition: initPosition,
                                          ));
                                          controller.update();
                                        },
                                        icon: Icon(
                                          Icons.location_on,
                                          color: appPrimaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 10.sp),
                                  padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 2.sp),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: appPrimaryColor, width: 1)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        controller.EndAddress.value,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: normal_h3Style.copyWith(color: appPrimaryColor),
                                      )),
                                      IconButton(
                                          onPressed: () async {
                                            PickResult data = await Get.to(PlacePicker(
                                              apiKey: googleAPIKey,
                                              popOnPickResult: true,
                                              onPlacePicked: (result) {
                                                setState(() {
                                                  controller.EndAddress.value = result.formattedAddress.toString();
                                                  controller.tourEndLng.value = result.geometry!.location.lng;
                                                  controller.tourEndLat.value = result.geometry!.location.lat;
                                                });
                                              },
                                              initialPosition: initPosition,
                                            ));
                                            controller.update();
                                          },
                                          icon: Icon(
                                            Icons.location_on,
                                            color: appPrimaryColor,
                                          ))
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    PickResult data = await Get.to(PlacePicker(
                                      apiKey: googleAPIKey,
                                      popOnPickResult: true,
                                      strictbounds: true,
                                      onPlacePicked: (result) {
                                        setState(() {
                                          controller.stopLatitude.value = result.geometry!.location.lat;
                                          controller.stopLongitude.value = result.geometry!.location.lng;
                                        });
                                      },
                                      initialPosition: initPosition,
                                    ));
                                    Get.to(ScreenAdminMobileAddStop(
                                      stop_id: FirebaseUtils.newId.toString(),
                                    ));
                                    controller.update();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
                                    margin: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: appPrimaryColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          LocaleKeys.AddStops.tr,
                                          style: normal_h3Style_bold.copyWith(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                (controller.stops.value.isEmpty)
                                    ? SizedBox()
                                    : CustomListviewBuilder(
                                        itemCount: controller.stops.value.length,
                                        scrollDirection: CustomDirection.vertical,
                                        itemBuilder: (BuildContext context, int index) {
                                          var stop = controller.stops.value[index];
                                          return GestureDetector(
                                            onTap: () {
                                              // Get.to(ScreenAdminMobileAddStop(stop_id: stop.id));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                                              margin: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(32),
                                                color: appPrimaryColor,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    LocaleKeys.StopN.tr.replaceAll("000", "${stop.stop_number}"),
                                                    style: normal_h3Style_bold.copyWith(color: Colors.white),
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {},
                                                          child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                              child: SvgPicture.asset(
                                                                "assets/svgs/fluent_delete-20-filled.svg",
                                                                color: Colors.white,
                                                              ))),
                                                      GestureDetector(
                                                          onTap: () {},
                                                          child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
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
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InputField(
                                        controller: controller.totalDistanceController.value,
                                        showBorder: true,
                                        label: LocaleKeys.TotalDistance.tr,
                                        // suffix: Text("km"),

                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InputField(
                                        controller: controller.totalTimeController.value,
                                        showBorder: true,
                                        keyboardType: TextInputType.number,
                                        label: LocaleKeys.TotalTime.tr,
                                        // suffix: Text("min"),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InputField(
                                        controller: controller.totalStopController.value,
                                        showBorder: true,
                                        readOnly: true,
                                        label: LocaleKeys.TotalStops.tr,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InputField(
                                        showBorder: true,
                                        controller: controller.sourceController.value,
                                        label: LocaleKeys.Source.tr,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        LocaleKeys.IntroductionVideoDescription.tr,
                                        style: normal_h2Style_bold,
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10.sp),
                                  padding: EdgeInsets.all(3.sp),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: appBoxShadow),
                                  child: InputField(
                                    margin: EdgeInsets.zero,
                                    maxLines: 10,
                                    controller: controller.descriptionController.value,
                                    // label: "Description",
                                    hint: LocaleKeys.WriteIntro.tr,
                                    textStyle: normal_h4Style.copyWith(color: Colors.grey),
                                    showBorder: false,
                                  ),
                                ),
                                StatefulBuilder(builder: (context, setState) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await PickFile([
                                            'mp4',
                                          ]).then((value) {
                                            controller.videosList = value!.paths.map((e) => e.toString()).toList();
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
                                      (controller.videosList.isEmpty)
                                          ? SizedBox()
                                          : Container(
                                              height: Get.height * .18,
                                              child: CustomListviewBuilder(
                                                itemBuilder: (BuildContext context, int index) {
                                                  return ItemVideoPlay(
                                                    url: controller.videosList[index],
                                                    onRemove: () {
                                                      controller.videosList.removeAt(index);
                                                      setState(() {});
                                                    },
                                                  );
                                                },
                                                itemCount: controller.videosList.length,
                                                scrollDirection: CustomDirection.horizontal,
                                              ),
                                            )
                                    ],
                                  );
                                }),
                                StatefulBuilder(builder: (context, setState) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await PickFile(['png', 'jpg', 'jpeg']).then((value) {
                                            controller.imagesList = value!.paths.map((e) => e.toString()).toList();
                                            controller.update();
                                            setState(() {});
                                          });
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
                                      (controller.imagesList.isEmpty)
                                          ? SizedBox()
                                          : Container(
                                              height: Get.height * .18,
                                              child: CustomListviewBuilder(
                                                itemBuilder: (BuildContext context, int index) {
                                                  controller.imageIndex = index;
                                                  return Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                                    height: (SizerUtil.orientation == Orientation.portrait) ? Get.height * .24 : Get.height * .3,
                                                    // width: Get.width*.36,
                                                    width: (SizerUtil.orientation == Orientation.portrait) ? Get.width * .4 : Get.width * .3,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: FileImage(
                                                          File(controller.imagesList[index]),
                                                        ),
                                                      ),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        controller.imagesList.removeAt(index);
                                                        setState(() {});
                                                      },
                                                      icon: SvgPicture.asset("assets/svgs/fluent_delete.svg"),
                                                    ),
                                                  );
                                                },
                                                itemCount: controller.imagesList.length,
                                                scrollDirection: CustomDirection.horizontal,
                                              ),
                                            ),
                                    ],
                                  );
                                }),
                                StatefulBuilder(builder: (context, setState) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await PickFile(
                                            [
                                              'mp3',
                                            ],
                                          ).then((value) {
                                            controller.audiosList = value!.paths.map((e) => e.toString()).toList();
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
                                      (controller.audiosList.isEmpty)
                                          ? Center(child: SizedBox())
                                          : CustomListviewBuilder(
                                              itemBuilder: (BuildContext context, int index) {
                                                return ItemAudioPlay(url: controller.audiosList[index],
                                                  onRemove: () {
                                                    controller.audiosList.removeAt(index);
                                                    setState(() {});
                                                  },

                                                );
                                              },
                                              itemCount: controller.audiosList.length,
                                              scrollDirection: CustomDirection.vertical,
                                            ),
                                    ],
                                  );
                                }),
                                CustomButton(
                                  text: LocaleKeys.Save.tr,
                                  onPressed: () async {
                                    var response = await controller.addTour().catchError((error){
                                      Get.snackbar("Alert", "Some Fields are missing");
                                    });
                                    if (response == 'success') {
                                      Get.snackbar("success", "Tour Uploaded successfully");
                                      Navigator.pop(context);
                                    } else {
                                      Get.snackbar("Alert", response);
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
                    });
                  });
            }),
      ),
    );
  }

// Future<List<String>> uploadFiles(List _images, id) async {
//   List<String> imagesUrls = [];
//
//   _images.forEach((_image) async {
//     ref = FirebaseStorage.instance
//         .ref()
//         .child('tours/$id/${_images.indexOf(_image)}');
//     UploadTask uploadTask = ref.putFile(_image);
//
//     imagesUrls.add(
//         await (await uploadTask.whenComplete(() {})).ref.getDownloadURL());
//   });
//   print(imagesUrls);
//   return imagesUrls;
// }
}

///
///
