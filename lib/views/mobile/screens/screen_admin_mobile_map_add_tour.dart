import 'dart:async';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_add_stop.dart';

import '../../../helpers/firebase_utils.dart';

class ScreenAdminMobileMapAddTour extends StatefulWidget {
  const ScreenAdminMobileMapAddTour({Key? key}) : super(key: key);

  @override
  _ScreenAdminMobileMapAddTourState createState() =>
      _ScreenAdminMobileMapAddTourState();
}

class _ScreenAdminMobileMapAddTourState
    extends State<ScreenAdminMobileMapAddTour> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: Text(LocaleKeys.PickTourLocation.tr),
        ),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              Positioned(
                  bottom: 0,
                  left: 40.sp,
                  right: 40.sp,
                  child: CustomButton(
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12.sp),
                    onPressed: () {
                Get.to(ScreenAdminMobileAddStop(
                  stop_id: FirebaseUtils.newId.toString(),
                  // stopLng: 00,
                  // stopLat: 00,
                ));

              }, text: 'Save',
                    textStyle: normal_h2Style_bold.copyWith(color: Colors.white),

              ))
            ],
          ),
        ),
      ),
    );
  }

}
