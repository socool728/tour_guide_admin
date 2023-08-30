import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_dashboard.dart';

class ScreenAdminMobileSplash extends StatelessWidget {
  const ScreenAdminMobileSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/splash.png")
            )
        ),
        child:  Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned.fill(child: Container(color: Colors.black.withOpacity(0.8),)),

            Center(
              child: GestureDetector(
                onTap: (){
                  Get.to(ScreenAdminMobileDashboard());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("App Logo",style: heading1_style.copyWith(color: Colors.white,fontSize: 37),),
                  Text(LocaleKeys.ExploreYourDestination.tr,style: heading1_style.copyWith(color: Colors.white,fontSize: 28),),

                ],),
              ),
            ),
          ],),
      ),
    );
  }
}
