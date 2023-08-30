import 'package:custom_utils/custom_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';

class ScreenAdminMobileAddVideos extends StatefulWidget {
  const ScreenAdminMobileAddVideos({Key? key}) : super(key: key);

  @override
  _ScreenAdminMobileAddVideosState createState() =>
      _ScreenAdminMobileAddVideosState();
}

class _ScreenAdminMobileAddVideosState
    extends State<ScreenAdminMobileAddVideos> {
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
          title: Text(LocaleKeys.AddVideos.tr),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20),
                child: DottedBorder(
                  dashPattern: [6, 6, 6, 6],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  strokeWidth: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      width: Get.width,
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/svgs/file_picker.svg"),
                          Text(LocaleKeys.UploadVideo.tr)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(20.sp),
                  itemCount: 8,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: Get.height * .18,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  "packages/custom_utils/assets/images/serviceImageOrder.png"))),
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/svgs/fluent_delete.svg"),
                      ),
                    );
                  },
                ),
              ),
              CustomButton(
                text: LocaleKeys.Save.tr,
                onPressed: () {
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
  }
}
