import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tour_guide_admin/extensions/num_extensions.dart';
import 'package:tour_guide_admin/generated/locales.g.dart';
import 'package:tour_guide_admin/models/tour.dart';
import 'package:tour_guide_admin/views/mobile/screens/screen_admin_mobile_edit_tour.dart';

import '../../helpers/helpers.dart';
import '../../models/stop.dart';

class ItemAdminTour extends StatelessWidget {
  Tour tour;
  List<Stop> stops = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: appBoxShadow,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(6.sp),
      padding: EdgeInsets.all(5.sp),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: Get.height * (SizerUtil.orientation == Orientation.landscape ? 2 : 1) * .16,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(tour.imagesUrl.isNotEmpty ? tour.imagesUrl.first : placeholder_url),
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 4.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.title,
                      style: normal_h3Style_bold.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      tour.description,
                      style: normal_h5Style.copyWith(fontWeight: FontWeight.w400),
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset("assets/svgs/distance.svg"),
                            ),
                            Text(
                              "${(tour.total_distance / 1000).roundToNum(2)} km",
                              style: normal_h5Style,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset("assets/svgs/time_requird.svg"),
                            ),
                            Text(
                              "${tour.total_time} mins",
                              style: normal_h5Style,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset("assets/svgs/location.svg"),
                            ),
                            Text(
                              LocaleKeys.StopN.tr.replaceAll("000", "${tour.total_stop}"),
                              style: normal_h5Style,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset("assets/svgs/car.svg"),
                            ),
                            Text(
                              tour.source,
                              style: normal_h5Style,
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.to(ScreenAdminMobileEditTour(
                                tour: tour,
                              ));
                            },
                            icon: SvgPicture.asset("assets/svgs/edit.svg")),
                        IconButton(
                            onPressed: () async {
                              Get.defaultDialog(title: "Delete Tour", content: Text("Are you sure to delete this tour?"), actions: [
                                OutlinedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("Cancel")),
                                OutlinedButton(
                                    onPressed: () async {
                                      await toursRef.doc(tour.id).delete();
                                      print("Tour Delete");
                                      await batchDelete();
                                      print("Stops Delete");
                                      // await deleteFromFirebaseStorage(tour.id);
                                      // print("Tour and Stops Delete from Storage");
                                      Get.back();
                                    },
                                    child: Text("Delete"))
                              ]);
                            },
                            icon: SvgPicture.asset("assets/svgs/fluent_delete-20-filled.svg")),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
  void getStops(id){
    stopsRef.snapshots().listen((event) {
      stops=event.docs.map((e) => Stop.fromMap(e.data() as Map<String, dynamic>)).toList();
      stops.where((element) => element.tour_id==id);
    });
  }
  Future<void> batchDelete() {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return  stopsRef.where('tour_id', isEqualTo: tour.id).get().then((querySnapshot) {

      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }
  deleteFromFirebaseStorage(id) async {
    return await FirebaseStorage.instance.ref().child('tours/$id').delete();
  }
  ItemAdminTour({
    required this.tour,
  });
}
