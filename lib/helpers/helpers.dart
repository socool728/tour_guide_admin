import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


var dbInstance = FirebaseFirestore.instance;
CollectionReference toursRef = dbInstance.collection("tours");
CollectionReference stopsRef = dbInstance.collection("stops");
String placeholder_url = "https://phito.be/wp-content/uploads/2020/01/placeholder.png";
String userPlaceHolder = "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png";
String appName = "Tour Guide Admin";
String googleAPIKey = "AIzaSyB2tfPVP5CVeqDZAtuMjzE_tz0K62Gb_LY";

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

Future<void> launchUrl(String url) async {
  url = !url.startsWith("http") ? ("http://" + url) : url;
  if (await canLaunch(url)) {
    launch(
      url,
      forceSafariVC: true,
      enableJavaScript: true,
      forceWebView: GetPlatform.isAndroid,
    );
  } else {
    throw 'Could not launch $url';
  }
}
//Add Audios
List files=[];
Future<FilePickerResult?> PickFile(List<String> type,) async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: type,

  );

  if (result != null) {
    PlatformFile file = result.files.first;
    print(file.name);
    print(file.bytes);
    print(files);
    print(file.size);
    print(file.extension);
    print(file.path);
  } else {
    Get.snackbar("Alert", "No File Pick");
  }
  return result;
}
Future<File> getVideoThumbnail(String url) async {
  var thumbTempPath = await VideoThumbnail.thumbnailFile(
    video: url,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.JPEG,
    maxHeight: 100,
    // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 100, // you can change the thumbnail quality here
  );
  return File(thumbTempPath!);
}
