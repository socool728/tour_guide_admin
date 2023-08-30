import 'dart:io';

import 'package:custom_utils/custom_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';

import '../../../helpers/helpers.dart';

class ScreenAdminMobileAddAudios extends StatefulWidget {
  const ScreenAdminMobileAddAudios({Key? key}) : super(key: key);

  @override
  _ScreenAdminMobileAddAudiosState createState() =>
      _ScreenAdminMobileAddAudiosState();
}

class _ScreenAdminMobileAddAudiosState
    extends State<ScreenAdminMobileAddAudios> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined), onPressed: () {
            Get.back();
          },),
          title: Text(LocaleKeys.AddAudios.tr),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(children: [
            GestureDetector(
              onTap: () async{

              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp,vertical: 20),
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
                          SvgPicture.asset("assets/svgs/audios.svg"),
                          Text(LocaleKeys.UploadAudio.tr)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: (files.isEmpty)?Center(child: Text("No Audio Added")):CustomListviewBuilder(itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed:() async{

                    },
                      icon: SvgPicture.asset("assets/svgs/playAudio.svg",height: 20.sp,),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        SvgPicture.asset("assets/svgs/audios.svg",height: 20.sp,),
                        SvgPicture.asset("assets/svgs/audios.svg",height: 20.sp),
                        SvgPicture.asset("assets/svgs/audios.svg",height: 20.sp,),
                        SvgPicture.asset("assets/svgs/audios.svg",height: 20.sp),
                        SvgPicture.asset("assets/svgs/audios.svg",height: 20.sp,),
                        SvgPicture.asset("assets/svgs/audios.svg",height: 20.sp),
                      ],
                    ),
                    IconButton(onPressed:(){},
                      icon: SvgPicture.asset("assets/svgs/fluent_delete-20-filled.svg"),
                    ),
                  ],
                ),
              );
            }, itemCount: files.length, scrollDirection: CustomDirection.vertical,

            )),
            CustomButton(text: LocaleKeys.Save.tr, onPressed: (){
              Get.back();
            },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              width: Get.width*.45,
            )


          ],),
        ),

      ),
    );
  }
}
