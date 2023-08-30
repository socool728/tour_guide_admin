import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tour_guide_admin/helpers/helpers.dart';
import 'package:tour_guide_admin/models/stop.dart';
import 'package:tour_guide_admin/models/tour.dart';

import '../helpers/firebase_utils.dart';

class TourController extends GetxController {
  String _id;

  TourController(this._id);

  Rx<double> tourStartLat = 0.0.obs;
  Rx<double> tourStartLng = 0.0.obs;
  Rx<double> tourEndLat = 0.0.obs;
  Rx<double> tourEndLng = 0.0.obs;
  Rx<String> StartAddress = "Add Start Location".obs;
  Rx<String> EndAddress = "Add End Location".obs;
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> totalDistanceController = TextEditingController()
      .obs;
  Rx<TextEditingController> totalStopController = TextEditingController(
      text: "0").obs;
  Rx<TextEditingController> totalTimeController = TextEditingController().obs;
  Rx<TextEditingController> startLocationController = TextEditingController()
      .obs;
  Rx<TextEditingController> endLocationController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> sourceController = TextEditingController().obs;
  List<String> imagesList = [];
  List<String> videosList = [];
  List<String> audiosList = [];
  int? imageIndex;
  List<String> videosUrls = [];
  List<String> imagesUrls = [];
  List<String> audiosUrls = [];
  Rx<List<Stop>> stops = Rx([]);

  //stop

  Map<String, List<String>> stopsImagesMap = {};
  Map<String, List<String>> stopsVideosMap = {};
  Map<String, List<String>> stopsAudiosMap = {};
  Map<String, String> stopsNamesMap = {};
  Map<String, String> stopsDescriptionsMap = {};
  Map<String, int> stopsNumbersMap = {};
  Map<String, double> stopsLatsMap = {};
  Map<String, double> stopsLngsMap = {};
  Rx<TextEditingController> stopTitleController = TextEditingController().obs;
  Rx<TextEditingController> stopDescriptionController = TextEditingController()
      .obs;
  Rx<TextEditingController> stopNumberController = TextEditingController(
      text: "1").obs;
  int? stopImageIndex;
  RxBool loading = false.obs;
  RxString wait = "Uploading".obs;
  Rx<double> stopLatitude = 0.0.obs;
  Rx<double> stopLongitude = 0.0.obs;

  Future<String> addTour() async {
    //Under Construction
    String response = '';
    String title = titleController.value.text.trim();
    double totalDistance = double.parse(
        totalDistanceController.value.text.trim());
    int totalTime = int.parse(totalTimeController.value.text.trim());
    int totalStop = int.parse(totalStopController.value.text.trim());
    String source = sourceController.value.text.trim();
    String description = descriptionController.value.text.trim();
    String startPoint = StartAddress.value;
    String endPoint = EndAddress.value;
    if (title.isEmpty) {
      return "Please Add Tour Title";
    }
    else if (startPoint == "Add Start Location") {
      return "Please Add Tour Starting Point";
    }
    else if (endPoint == "Add End Location") {
      return "Please Add Tour Ending Point";
    }
    else if (totalDistance <= 0) {
      return "Please Add Tour total distance ";
    }
    else if (totalTime <= 0) {
      return "Please Add Tour total Time required for tour ";
    }
    else if (source.isEmpty) {
      return "Please Add Tour Source ";
    }
    else if (description.isEmpty) {
      return "Please Add Tour Description";
    }
    // else if (videosList.isEmpty) {
    //   return "Please Add At least one Video";
    // }
    // else if (imagesList.isEmpty) {
    //   return "Please Add At least one Image";
    // }
    // else if (audiosList.isEmpty) {
    //   return "Please Add At least one Audio";
    // }
    else {
      loading.value = true;
      wait.value = "Uploading Tour";
      imagesUrls = await FirebaseUtils.uploadMultipleFiles(
          imagesList, "tours/$_id/images/", extension: "png",
          onProgress: (index, progress) {
            print("$index => $progress");
          });
      videosUrls = await FirebaseUtils.uploadMultipleFiles(
          videosList, "tours/$_id/videos/", extension: "mp4",
          onProgress: (index, progress) {
            print("$index => $progress");
          });
      audiosUrls = await FirebaseUtils.uploadMultipleFiles(
          audiosList, "tours/$_id/audios/", extension: "mp3",
          onProgress: (index, progress) {
            print("$index => $progress");
          });
      // await uploadStop(FirebaseUtils.newId.toString());
      var tour = Tour(
          id: _id,
          title: title,
          time_stamp: DateTime
              .now()
              .millisecondsSinceEpoch,
          starting_point: startPoint,
          ending_point: endPoint,
          source: source,
          description: description,
          total_stop: totalStop,
          total_time: totalTime,
          total_distance: totalDistance,
          audiosUrl: audiosUrls,
          imagesUrl: imagesUrls,
          videosUrl: videosUrls,
          startLat: tourStartLat.value,
          startLng: tourStartLng.value,
          endLat: tourEndLat.value,
          endLng: tourEndLng.value);
      await toursRef.doc(tour.id).set(tour.toMap()).then((value) {
        response = 'success';
      }).catchError((error) {
        response = error;
      });
      wait.value = "Starting upload of stops";
      await Future.delayed(Duration(milliseconds: 500));

      await Future.forEach(stops.value, (Stop element) async {
        response = await uploadStop(element.id);
      });
      loading.value = false;
    }
    return response;
  }

  Future<String> uploadStop(String stop_id) async {
    String response = '';
    var stop = stops.value
        .where((element) => element.id == stop_id)
        .toList()
        .first;

    wait.value = "Stop ${stop.stop_number} (10%)";

    List<String> stopVideosUrls = await FirebaseUtils.uploadMultipleFiles(
        stopsVideosMap[stop_id] ?? [],
        "tours/${_id}/stops/${stop_id}/stopVideo/",
        extension: "mp4", onProgress: (index, progress) {
      print("$index => $progress");
    });

    wait.value = "Stop ${stop.stop_number} (40%)";

    List<String> stopImagesUrls = await FirebaseUtils.uploadMultipleFiles(
        stopsImagesMap[stop_id] ?? [],
        "tours/${_id}/stops/$stop_id/stopImages/",
        extension: "png", onProgress: (index, progress) {
      print("$index => $progress");
    });

    wait.value = "Stop ${stop.stop_number} (70%)";

    List<String> stopAudiosUrls = await FirebaseUtils.uploadMultipleFiles(
        stopsAudiosMap[stop_id] ?? [],
        "tours/${_id}/stops/$stop_id/stopAudios/",
        extension: "mp3", onProgress: (index, progress) {
      print("$index => $progress");
    });

    wait.value = "Stop ${stop.stop_number} (100%)";

    stop = stop.copyWith(stopImagesUrl: stopImagesUrls,
        stopVideosUrl: stopVideosUrls,
        stopAudiosUrl: stopAudiosUrls);

    await stopsRef.doc(stop.id).set(stop.toMap()).then((value) {
      response = "success";
    });

    return response;
  }

  String saveStop(String id) {
    String response = '';
    String stopTitle = stopTitleController.value.text;
    String stopDescription = stopDescriptionController.value.text;
    int stopNumber = int.tryParse(stopNumberController.value.text) ?? 0;
    if (stopTitle.isEmpty) {
      return "Please Add Stop Title";
    }
    else if (stopDescription.isEmpty) {
      return "Please Add Stop Description";
    }
    // else if (stopsVideosMap.isEmpty) {
    //   return "Please Add At least one Video";
    // }
    // else if (stopsImagesMap.isEmpty) {
    //   return "Please Add At least one Image";
    // }
    //
    // else if (stopsAudiosMap.isEmpty) {
    //   return "Please Add At least one Audio";
    // }


    else {
      stopsNamesMap[id] = stopTitleController.value.text;
      stopsDescriptionsMap[id] = stopDescriptionController.value.text;
      stopsNumbersMap[id] = int.tryParse(stopNumberController.value.text) ?? 0;
      var newStop = Stop(
          id: id,
          tour_id: _id,
          name: stopsNamesMap[id] ?? "",
          description: stopsDescriptionsMap[id] ?? "",
          time_stamp: DateTime
              .now()
              .millisecondsSinceEpoch,
          stop_number: stopsNumbersMap[id] ?? 1,
          latitude: stopsLatsMap[id] ?? stopLatitude.value,
          longitude: stopsLngsMap[id] ?? stopLongitude.value,
          stopImagesUrl: stopsImagesMap[id] ?? [],
          stopAudiosUrl: stopsAudiosMap[id] ?? [],
          stopVideosUrl: stopsVideosMap[id] ?? []);
      bool alreadyExists = stops.value
          .where((element) => element.id == newStop.id)
          .toList()
          .isNotEmpty;
      if (alreadyExists) {
        int index = stops.value.indexWhere((element) =>
        element.id == newStop.id);
        stops.value[index] = newStop;
        response = "Stop Already Exists";
      } else {
        stops.value.add(newStop);
        response = "success";
      }
      update();
      stops.refresh();
      stopTitleController.value.clear();
      stopDescriptionController.value.clear();
      totalStopController.value.text = "${stops.value.length}";
      var num = int.tryParse(stopNumberController.value.text) ?? 1;
      num++;
      // Get.back();
      stopNumberController.value.text = "$num";
    }
    return response;
  }


  //Add Extra Stop
  List<String> addStopImagesList = [];
  List<String> addStopAudioList = [];
  List<String> addStopVideoList = [];
  List<String> addStopImagesUrl = [];
  List<String> addStopAudioUrl = [];
  List<String> addStopVideoUrl = [];
  Future<String> addExtraStop(String id) async {
    String response = "";
    String title = stopTitleController.value.text.trim();
    int number = int.tryParse(stopNumberController.value.text.trim()) ?? 1;
    String description = stopDescriptionController.value.text.trim();
    if (title.isEmpty || number == 0 || description.isEmpty) {
      return response="All Fields Required";
    }
    String stop_id = DateTime.now().millisecondsSinceEpoch.toString();
    loading.value=true;
    wait.value="uploading Images";
    addStopImagesUrl = await FirebaseUtils.uploadMultipleFiles(
        addStopImagesList, "tours/${id}/stops/$stop_id/stopImages/",
        extension: "png", onProgress: (index, progress) {
      print("$index => $progress");
    });
    wait.value="uploading Videos";
    addStopVideoUrl = await FirebaseUtils.uploadMultipleFiles(
        addStopVideoList, "tours/${id}/stops/${stop_id}/stopVideo/",
        extension: "mp4", onProgress: (index, progress) {
      print("$index => $progress");
    });
    wait.value="uploading Audios";
    addStopAudioUrl = await FirebaseUtils.uploadMultipleFiles(
        addStopAudioList, "tours/${id}/stops/$stop_id/stopAudios/",
        extension: "mp3", onProgress: (index, progress) {
      print("$index => $progress");
    });
    wait.value="uploading Stop";
    var latitude=stopLatitude.value;
    var longitude=stopLatitude.value;
    var stop = Stop(
      id: stop_id,
      tour_id: id,
      name: title,
      description: description,
      time_stamp: DateTime.now().millisecondsSinceEpoch,
      stop_number: number,
      latitude: latitude,
      longitude: longitude,
      stopImagesUrl: addStopImagesUrl,
      stopAudiosUrl: addStopAudioUrl,
      stopVideosUrl: addStopVideoUrl,);
    await stopsRef.doc(stop_id).set(stop.toMap()).then((value) {
      loading.value=false;
      response="success";
    }).catchError((error){
      response=error.toString();
    });
    return response;
  }
}
